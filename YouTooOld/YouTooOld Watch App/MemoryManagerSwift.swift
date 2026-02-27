//
//  MemoryManagerSwift.swift
//  YouTooOld Watch App
//

import os
import Foundation

final class MemoryManagerSwift {
    static let shared = MemoryManagerSwift()

    private init() {}

    func availableMemoryMB() -> Int {
        Int(os_proc_available_memory() / 1024 / 1024)
    }

    func checkMemoryAndCleanupIfNeeded() {
        guard availableMemoryMB() < Constants.lowMemoryThresholdMB else { return }
        ThumbnailLoader.shared.purge()
    }
}
