//
//  SearchResult.swift
//  YouTooOld WatchKit Extension
//

import Foundation

struct SearchResult: Codable {
    let videos: [VideoModel]?
}

extension VideoModel {
    init?(searchItem: SearchResponseItem) {
        guard let id = searchItem.videoId else { return nil }
        self.videoId = id
        self.title = searchItem.title ?? ""
        self.author = searchItem.author ?? ""
        self.viewCount = searchItem.viewCount
        self.lengthSeconds = searchItem.lengthSeconds
        self.videoThumbnails = searchItem.videoThumbnails?.map { VideoThumbnail(quality: $0.quality, url: $0.url, width: $0.width, height: $0.height) }
        self.formatStreams = nil
        self.adaptiveFormats = nil
    }
}

struct SearchResponseItem: Codable {
    let type: String?
    let title: String?
    let videoId: String?
    let author: String?
    let viewCount: Int?
    let lengthSeconds: Int?
    let videoThumbnails: [SearchThumbnail]?
}

struct SearchThumbnail: Codable {
    let quality: String?
    let url: String
    let width: Int?
    let height: Int?
}
