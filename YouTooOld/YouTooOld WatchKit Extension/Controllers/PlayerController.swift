//
//  PlayerController.swift
//  YouTooOld WatchKit Extension
//

import WatchKit
import Foundation
import AVFoundation

final class PlayerController: WKInterfaceController {

    @IBOutlet private weak var moviePlayer: WKInterfaceInlineMovie!
    @IBOutlet private weak var titleLabel: WKInterfaceLabel!
    @IBOutlet private weak var rewindButton: WKInterfaceButton!
    @IBOutlet private weak var forwardButton: WKInterfaceButton!
    @IBOutlet private weak var prevButton: WKInterfaceButton!
    @IBOutlet private weak var nextButton: WKInterfaceButton!

    private var context: PlayerContext?
    private var avPlayer: AVPlayer?

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.context = context as? PlayerContext
    }

    override func willActivate() {
        super.willActivate()
        MemoryManager.shared.checkMemoryAndCleanupIfNeeded()
        guard let ctx = context else { return }
        if ctx.isAudioOnly {
            playAudio(url: ctx.streamURL)
        } else {
            playVideo(url: ctx.streamURL)
        }
        updateNavButtons()
    }

    override func didDeactivate() {
        super.didDeactivate()
        if context?.isAudioOnly == true {
            avPlayer?.pause()
        }
    }

    private func playVideo(url: URL) {
        moviePlayer.setMovieURL(url)
        moviePlayer.setLoops(false)
        moviePlayer.setVideoGravity(.resizeAspect)
        moviePlayer.playFromBeginning()
    }

    private func playAudio(url: URL) {
        moviePlayer.setHidden(true)
        let playerItem = AVPlayerItem(url: url)
        avPlayer = AVPlayer(playerItem: playerItem)
        avPlayer?.play()
    }

    private func updateNavButtons() {
        guard let ctx = context else { return }
        let list = ctx.list
        prevButton.setEnabled(ctx.index > 0)
        nextButton.setEnabled(ctx.index < list.count - 1 && list.count > 0)
    }

    @IBAction func rewindTapped() {
        // WKInterfaceInlineMovie has no seek API on watchOS 8; keep for future or no-op
        WKInterfaceDevice.current().play(.click)
    }

    @IBAction func forwardTapped() {
        WKInterfaceDevice.current().play(.click)
    }

    @IBAction func prevTapped() {
        guard let ctx = context, ctx.index > 0 else { return }
        let newIndex = ctx.index - 1
        let video = ctx.list[newIndex]
        loadVideoAtIndex(newIndex, video: video)
    }

    @IBAction func nextTapped() {
        guard let ctx = context, ctx.index < ctx.list.count - 1 else { return }
        let newIndex = ctx.index + 1
        let video = ctx.list[newIndex]
        loadVideoAtIndex(newIndex, video: video)
    }

    private func loadVideoAtIndex(_ index: Int, video: VideoModel) {
        guard let list = context?.list else { return }
        InvidiousAPI.shared.video(id: video.videoId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let v):
                    if let url = StreamResolver.resolveVideoURL(video: v) {
                        self?.context = PlayerContext(streamURL: url, isAudioOnly: self?.context?.isAudioOnly ?? false, list: list, index: index)
                        self?.playVideo(url: url)
                        self?.updateNavButtons()
                    }
                case .failure:
                    break
                }
            }
        }
    }
}
