//
//  SettingsController.swift
//  YouTooOld WatchKit Extension
//

import WatchKit
import Foundation

final class SettingsController: WKInterfaceController {

    @IBOutlet private weak var qualityPicker: WKInterfacePicker!
    @IBOutlet private weak var instancePicker: WKInterfacePicker!
    @IBOutlet private weak var memoryLabel: WKInterfaceLabel!
    @IBOutlet private weak var clearCacheButton: WKInterfaceButton!

    private let qualityOptions: [(String, VideoQuality)] = [
        ("144p", .p144),
        ("240p", .p240),
        ("360p", .p360)
    ]

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setupPickers()
    }

    override func willActivate() {
        super.willActivate()
        updateMemoryLabel()
    }

    private func setupPickers() {
        qualityPicker.setItems(qualityOptions.map { item in
            let pickerItem = WKPickerItem()
            pickerItem.title = item.0
            return pickerItem
        })
        let savedQuality = SettingsManager.shared.videoQuality
        if let idx = qualityOptions.firstIndex(where: { $0.1 == savedQuality }) {
            qualityPicker.setSelectedItemIndex(idx)
        }

        let instances = InstanceManager.shared.instanceURLs
        instancePicker.setItems(instances.enumerated().map { _, url in
            let item = WKPickerItem()
            item.title = URL(string: url)?.host ?? url
            return item
        })
        instancePicker.setSelectedItemIndex(InstanceManager.shared.currentIndex)
    }

    private func updateMemoryLabel() {
        let mb = MemoryManager.shared.availableMemoryMB()
        memoryLabel.setText("Memory: \(mb) MB")
    }

    @IBAction func qualityPickerChanged(_ value: Int) {
        guard value >= 0, value < qualityOptions.count else { return }
        SettingsManager.shared.videoQuality = qualityOptions[value].1
    }

    @IBAction func instancePickerChanged(_ value: Int) {
        InstanceManager.shared.selectInstance(at: value)
    }

    @IBAction func clearCacheTapped() {
        ImageLoader.shared.purge()
        WKInterfaceDevice.current().play(.click)
        updateMemoryLabel()
    }
}
