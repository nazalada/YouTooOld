//
//  VideoModel.swift
//  YouTooOld WatchKit Extension
//

import Foundation

struct VideoModel: Codable {
    let videoId: String
    let title: String
    let author: String
    let viewCount: Int?
    let lengthSeconds: Int?
    let videoThumbnails: [VideoThumbnail]?
    let formatStreams: [FormatStream]?
    let adaptiveFormats: [AdaptiveFormat]?

    var thumbnailURL: URL? {
        let thumb = videoThumbnails?.first { $0.quality == "medium" }
            ?? videoThumbnails?.first { $0.quality == "default" }
            ?? videoThumbnails?.first
        guard let urlString = thumb?.url else { return nil }
        return URL(string: urlString)
    }

    enum CodingKeys: String, CodingKey {
        case videoId, title, author, viewCount, lengthSeconds
        case videoThumbnails, formatStreams, adaptiveFormats
    }
}

struct VideoThumbnail: Codable {
    let quality: String?
    let url: String
    let width: Int?
    let height: Int?

    init(quality: String?, url: String, width: Int?, height: Int?) {
        self.quality = quality
        self.url = url
        self.width = width
        self.height = height
    }
}

struct FormatStream: Codable {
    let url: String?
    let type: String?
    let quality: String?
    let container: String?
    let resolution: String?
}

struct AdaptiveFormat: Codable {
    let url: String?
    let type: String?
    let bitrate: Int?
    let container: String?
    let audioQuality: String?
}
