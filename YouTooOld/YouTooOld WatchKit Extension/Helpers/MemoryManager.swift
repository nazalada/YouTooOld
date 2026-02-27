//
//  MemoryManager.swift
//  YouTooOld WatchKit Extension
//

import os
import WatchKit
import Foundation

final class MemoryManager {

    static let shared = MemoryManager()

    private init() {}

    func availableMemoryMB() -> Int {
        let available = os_proc_available_memory()
        return Int(available / 1024 / 1024)
    }

    func checkMemoryAndCleanupIfNeeded() {
        guard availableMemoryMB() < Constants.lowMemoryThresholdMB else { return }
        ImageLoader.shared.purge()
        DispatchQueue.main.async {
            WKExtension.shared().visibleInterfaceController?.popToRootController()
        }
    }
}
