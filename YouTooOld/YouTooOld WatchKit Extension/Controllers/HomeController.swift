//
//  HomeController.swift
//  YouTooOld WatchKit Extension
//

import WatchKit
import Foundation

final class HomeController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    @IBAction func searchTapped() {
        presentController(withName: "SearchController", context: nil)
    }

    @IBAction func trendingTapped() {
        pushController(withName: "VideoListController", context: VideoListContext(mode: .trending, query: nil))
    }

    @IBAction func popularTapped() {
        pushController(withName: "VideoListController", context: VideoListContext(mode: .popular, query: nil))
    }

    @IBAction func settingsTapped() {
        pushController(withName: "SettingsController", context: nil)
    }
}

struct VideoListContext {
    enum Mode { case trending, popular, search }
    let mode: Mode
    let query: String?
}
