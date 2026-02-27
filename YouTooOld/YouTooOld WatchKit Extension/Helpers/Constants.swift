//
//  Constants.swift
//  YouTooOld WatchKit Extension
//

import Foundation

enum Constants {
    static let apiTimeout: TimeInterval = 15
    static let streamTimeout: TimeInterval = 30
    static let userAgent = "YouTooOld/1.0 watchOS"
    static let maxConcurrentNetworkTasks = 2
    static let thumbnailTargetSize = (width: 156, height: 88)
    static let maxVideosInMemory = 10
    static let lowMemoryThresholdMB = 20
}
