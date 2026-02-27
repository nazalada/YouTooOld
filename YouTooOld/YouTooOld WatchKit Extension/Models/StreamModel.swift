//
//  StreamModel.swift
//  YouTooOld WatchKit Extension
//

import Foundation

enum VideoQuality: String, Codable, CaseIterable {
    case p144 = "144p"
    case p240 = "240p"
    case p360 = "360p"

    var sortOrder: Int {
        switch self {
        case .p144: return 0
        case .p240: return 1
        case .p360: return 2
        }
    }
}

struct StreamModel {
    let url: URL
    let quality: String
    let isAudioOnly: Bool
}
