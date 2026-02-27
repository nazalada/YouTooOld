//
//  InstanceManager.swift
//  YouTooOld WatchKit Extension
//

import Foundation

final class InstanceManager {

    static let shared = InstanceManager()

    private let baseURLs = [
        "https://vid.puffyan.us",
        "https://invidious.snopyta.org",
        "https://yewtu.be",
        "https://invidious.kavin.rocks"
    ]
    private let cooldownSeconds: TimeInterval = 300
    private var failedUntil: [String: Date] = [:]
    private let queue = DispatchQueue(label: "com.youtooold.instance")
    private var _currentIndex: Int = 0
    private let indexKey = "invidiousInstanceIndex"

    var currentIndex: Int {
        get { queue.sync { _currentIndex } }
        set { queue.async { self._currentIndex = newValue } }
    }

    var instanceURLs: [String] { baseURLs }

    var baseURL: String {
        queue.sync { baseURLs[_currentIndex] }
    }

    private init() {
        let idx = UserDefaults.standard.integer(forKey: indexKey)
        if idx >= 0 && idx < baseURLs.count {
            _currentIndex = idx
        }
    }

    func selectInstance(at index: Int) {
        guard index >= 0, index < baseURLs.count else { return }
        queue.async {
            self._currentIndex = index
            UserDefaults.standard.set(index, forKey: self.indexKey)
        }
    }

    func markFailed(baseURL: String) {
        queue.async {
            self.failedUntil[baseURL] = Date().addingTimeInterval(self.cooldownSeconds)
        }
    }

    func switchToNext() {
        queue.async {
            let start = self._currentIndex
            for i in 1..<self.baseURLs.count {
                let idx = (start + i) % self.baseURLs.count
                let url = self.baseURLs[idx]
                if self.failedUntil[url] ?? .distantPast < Date() {
                    self._currentIndex = idx
                    UserDefaults.standard.set(idx, forKey: self.indexKey)
                    return
                }
            }
        }
    }
}
