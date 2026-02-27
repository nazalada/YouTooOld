//
//  ExtensionDelegate.swift
//  YouTooOld WatchKit Extension
//

import WatchKit

final class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused while the application was inactive.
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state.
    }

    func applicationWillEnterForeground() {
        MemoryManager.shared.checkMemoryAndCleanupIfNeeded()
    }

    func applicationDidEnterBackground() {
        // Use this method to release shared resources, save user data, invalidate timers, etc.
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            task.setTaskCompletedWithSnapshot(false)
        }
    }
}
