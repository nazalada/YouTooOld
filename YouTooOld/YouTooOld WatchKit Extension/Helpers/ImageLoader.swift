//
//  ImageLoader.swift
//  YouTooOld WatchKit Extension
//

import WatchKit
import Foundation

final class ImageLoader {

    static let shared = ImageLoader()

    private let session: URLSession
    private var activeTasks: [String: URLSessionDataTask] = [:]
    private let queue = DispatchQueue(label: "com.youtooold.imageloader")

    private init() {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = Constants.apiTimeout
        config.httpAdditionalHeaders = ["User-Agent": Constants.userAgent]
        session = URLSession(configuration: config)
    }

    func loadThumbnail(url: URL, into image: WKInterfaceImage) {
        let key = url.absoluteString
        queue.async { [weak self] in
            self?.activeTasks[key]?.cancel()
        }
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else { return }
            let downsized = self?.downsample(data: data) ?? nil
            DispatchQueue.main.async {
                if let img = downsized {
                    image.setImage(img)
                }
            }
            self?.queue.async {
                self?.activeTasks[key] = nil
            }
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
