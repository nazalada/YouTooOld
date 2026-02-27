//
//  WatchAppContexts.swift
//  YouTooOld Watch App
//

import Foundation

struct VideoListContext {
    enum Mode { case trending, popular, search }
    let mode: Mode
    let query: String?
}

struct VideoDetailContext {
    let videoId: String
    let list: [VideoModel]
    let index: Int
}

struct PlayerContext {
    let streamURL: URL
    let isAudioOnly: Bool
    let list: [VideoModel]
    let index: Int
}
