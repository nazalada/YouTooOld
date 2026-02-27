//
//  VideoRowController.swift
//  YouTooOld WatchKit Extension
//

import WatchKit
import Foundation

final class VideoRowController: NSObject {

    @IBOutlet private weak var thumbnailImage: WKInterfaceImage!
    @IBOutlet private weak var titleLabel: WKInterfaceLabel!
    @IBOutlet private weak var channelLabel: WKInterfaceLabel!

    func configure(with video: VideoModel) {
        titleLabel.setText(video.title)
        channelLabel.setText(video.author)
        thumbnailImage.setImage(nil)
        if let url = video.thumbnailURL {
            ImageLoader.shared.loadThumbnail(url: url, into: thumbnailImage)
        }
    }
}
