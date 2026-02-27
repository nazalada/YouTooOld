//
//  SearchController.swift
//  YouTooOld WatchKit Extension
//

import WatchKit
import Foundation

final class SearchController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    override func willActivate() {
        super.willActivate()
        startTextInput()
    }

    private func startTextInput() {
        presentTextInputController(
            withSuggestions: nil,
            allowedInputMode: .allowEmoji
        ) { [weak self] results in
            guard let self = self, let items = results as? [String], let query = items.first?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty else {
                self?.dismiss()
                return
            }
            self.dismiss()
            DispatchQueue.main.async {
                self.pushController(withName: "VideoListController", context: VideoListContext(mode: .search, query: query))
            }
        }
    }
}
