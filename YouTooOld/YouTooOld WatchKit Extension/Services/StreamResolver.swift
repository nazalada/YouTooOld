//
//  StreamResolver.swift
//  YouTooOld WatchKit Extension
//

import Foundation

enum StreamResolver {

    private static let qualityOrder: [VideoQuality] = [.p360, .p240, .p144]

    static func resolveVideoURL(video: VideoModel) -> URL? {
        let maxQuality = SettingsManager.shared.videoQuality
        guard let streams = video.formatStreams else { return nil }
        let videoStreams = streams.filter { ($0.type ?? "").hasPrefix("video/") && $0.url != nil }
        for q in qualityOrder {
            guard q.sortOrder <= maxQuality.sortOrder else { continue }
            if let stream = videoStreams.first(where: { $0.quality == q.rawValue || $0.resolution == q.rawValue }),
               let urlString = stream.url,
               let url = URL(string: urlString) {
                return url
            }
        }
        if let any = videoStreams.first, let urlString = any.url, let url = URL(string: urlString) {
            return url
        }
        return nil
    }

    static func resolveAudioURL(video: VideoModel) -> URL? {
        guard let formats = video.adaptiveFormats else { return nil }
        let audio = formats.first { ($0.type ?? "").hasPrefix("audio/") && $0.url != nil }
        guard let urlString = audio?.url, let url = URL(string: urlString) else { return nil }
        return url
    }
}
