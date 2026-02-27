//
//  PlayerView.swift
//  YouTooOld Watch App
//

import SwiftUI
import AVFoundation
import WatchKit

struct PlayerView: View {
    let context: PlayerContext
    @State private var currentURL: URL
    @State private var list: [VideoModel]
    @State private var index: Int
    @State private var audioPlayer: AVPlayer?

    init(context: PlayerContext) {
        self.context = context
        _currentURL = State(initialValue: context.streamURL)
        _list = State(initialValue: context.list)
        _index = State(initialValue: context.index)
    }

    var body: some View {
        VStack(spacing: 4) {
            if context.isAudioOnly {
                Text("Audio")
                    .font(.caption)
                if audioPlayer != nil {
                    Text("Playing…").font(.caption2)
                }
            } else {
                InlineMovieView(url: currentURL)
            }
            HStack {
                Button("Prev") { prev() }
                    .disabled(index <= 0)
                Button("Next") { next() }
                    .disabled(index >= list.count - 1)
            }
            .buttonStyle(.bordered)
        }
        .navigationTitle("Play")
        .onAppear {
            MemoryManagerSwift.shared.checkMemoryAndCleanupIfNeeded()
            if context.isAudioOnly {
                let item = AVPlayerItem(url: currentURL)
                audioPlayer = AVPlayer(playerItem: item)
                audioPlayer?.play()
            }
        }
        .onDisappear {
            if context.isAudioOnly { audioPlayer?.pause() }
        }
    }

    private func prev() {
        guard index > 0 else { return }
        playAtIndex(index - 1)
    }

    private func next() {
        guard index < list.count - 1 else { return }
        playAtIndex(index + 1)
    }

    private func playAtIndex(_ newIndex: Int) {
        let video = list[newIndex]
        InvidiousAPI.shared.video(id: video.videoId) { result in
            DispatchQueue.main.async {
                guard case .success(let v) = result else { return }
                let url: URL?
                if context.isAudioOnly {
                    url = StreamResolver.resolveAudioURL(video: v)
                } else {
                    url = StreamResolver.resolveVideoURL(video: v)
                }
                if let u = url {
                    currentURL = u
                    index = newIndex
                    if context.isAudioOnly {
                        audioPlayer?.replaceCurrentItem(with: AVPlayerItem(url: u))
                        audioPlayer?.play()
                    }
                }
            }
        }
    }
}
