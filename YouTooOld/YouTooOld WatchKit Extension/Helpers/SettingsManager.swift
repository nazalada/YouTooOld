//
//  SettingsManager.swift
//  YouTooOld WatchKit Extension
//

import Foundation

final class SettingsManager {

    static let shared = SettingsManager()

    private let qualityKey = "videoQuality"
    private let defaults = UserDefaults.standard

    var videoQuality: VideoQuality {
        get {
            guard let raw = defaults.string(forKey: qualityKey),
                  let q = VideoQuality(rawValue: raw) else { return .p360 }
            return q
        }
        set {
            defaults.set(newValue.rawValue, forKey: qualityKey)
        }
    }

    private init() {}
}
