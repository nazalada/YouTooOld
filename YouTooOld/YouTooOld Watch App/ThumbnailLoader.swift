//
//  ThumbnailLoader.swift
//  YouTooOld Watch App
//

import Foundation
import UIKit

final class ThumbnailLoader {
    static let shared = ThumbnailLoader()

    private let session: URLSession
    private var activeTasks: [String: URLSessionDataTask] = [:]
    private let queue = DispatchQueue(label: "com.youtooold.thumbloader")

    private init() {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = Constants.apiTimeout
        config.httpAdditionalHeaders = ["User-Agent": Constants.userAgent]
        session = URLSession(configuration: config)
    }

    func loadThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString
        queue.async { [weak self] in
            self?.activeTasks[key]?.cancel()
        }
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { DispatchQueue.main.async { completion(nil) }; return }
            let img = self?.downsample(data: data)
            DispatchQueue.main.async { completion(img) }
            self?.queue.async { self?.activeTasks[key] = nil }
        }
        queue.async { [weak self] in
            self?.activeTasks[key] = task
        }
        task.resume()
    }

    private func downsample(data: Data) -> UIImage? {
        let targetW = Constants.thumbnailTargetSize.width
        let targetH = Constants.thumbnailTargetSize.height
        guard let src = UIImage(data: data) else { return nil }
        let size = src.size
        let scale = min(CGFloat(targetW) / size.width, CGFloat(targetH) / size.height, 1)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1)
        src.draw(in: CGRect(origin: .zero, size: newSize))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    func purge() {
        queue.async { [weak self] in
            self?.activeTasks.values.forEach { $0.cancel() }
            self?.activeTasks.removeAll()
        }
    }
}
