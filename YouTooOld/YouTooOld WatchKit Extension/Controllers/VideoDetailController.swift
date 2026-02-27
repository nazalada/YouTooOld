//
//  VideoDetailController.swift
//  YouTooOld WatchKit Extension
//

import WatchKit
import Foundation

final class VideoDetailController: WKInterfaceController {

    @IBOutlet private weak var thumbnailImage: WKInterfaceImage!
    @IBOutlet private weak var titleLabel: WKInterfaceLabel!
    @IBOutlet private weak var metaLabel: WKInterfaceLabel!
    @IBOutlet private weak var playButton: WKInterfaceButton!
    @IBOutlet private weak var playAudioButton: WKInterfaceButton!

    private var context: VideoDetailContext?
    private var video: VideoModel?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.context = context as? VideoDetailContext
    }

    override func willActivate() {
        super.willActivate()
        guard let ctx = context else { return }
        if video == nil {
            loadVideo(id: ctx.videoId)
        }
    }

    private func loadVideo(id: String) {
        playButton.setEnabled(false)
        playAudioButton.setEnabled(false)
        InvidiousAPI.shared.video(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let v):
                    self?.video = v
                    self?.display(video: v)
                    self?.playButton.setEnabled(true)
                    self?.playAudioButton.setEnabled(true)
                case .failure:
                    self?.showError("Video load failed")
                }
            }
        }
    }

    private func display(video: VideoModel) {
        titleLabel.setText(video.title)
        metaLabel.setText("\(video.author) • \(video.viewCount ?? 0) views")
        if let thumbURL = video.thumbnailURL {
            ImageLoader.shared.loadThumbnail(url: thumbURL, into: thumbnailImage)
        }
    }

    @IBAction func playTapped() {
        guard let v = video, let ctx = context else { return }
        guard let url = StreamResolver.resolveVideoURL(video: v) else {
            showError("No stream")
            return
        }
        pushController(withName: "PlayerController", context: PlayerContext(streamURL: url, isAudioOnly: false, list: ctx.list, index: ctx.index))
    }

    @IBAction func playAudioTapped() {
        guard let v = video, let ctx = context else { return }
        guard let url = StreamResolver.resolveAudioURL(video: v) else {
            showError("No audio")
            return
        }
        pushController(withName: "PlayerController", context: PlayerContext(streamURL: url, isAudioOnly: true, list: ctx.list, index: ctx.index))
    }

    private func showError(_ message: String) {
        titleLabel.setText(message)
    }
}

struct PlayerContext {
    let streamURL: URL
    let isAudioOnly: Bool
    let list: [VideoModel]
    let index: Int
}
