//
//  VideoDetailView.swift
//  YouTooOld Watch App
//

import SwiftUI

struct VideoDetailView: View {
    let context: VideoDetailContext
    @State private var video: VideoModel?
    @State private var thumb: UIImage?
    @State private var errorMessage: String?

    var body: some View {
        Group {
            if let v = video {
                VStack(alignment: .leading, spacing: 6) {
                    thumbnailView
                    Text(v.title)
                        .font(.caption)
                    Text("\(v.author) • \(v.viewCount ?? 0) views")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    HStack {
                        playVideoLink
                        playAudioLink
                    }
                    .buttonStyle(.bordered)
                }
            } else if let msg = errorMessage {
                Text(msg).foregroundStyle(.secondary)
            } else {
                ProgressView("Loading…")
            }
        }
        .navigationTitle("Video")
        .task {
            loadVideo()
        }
    }

    @ViewBuilder
    private var thumbnailView: some View {
        if let img = thumb {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 60)
                .clipped()
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 60)
        }
    }

    private func loadVideo() {
        InvidiousAPI.shared.video(id: context.videoId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let v):
                    video = v
                    if let url = v.thumbnailURL {
                        ThumbnailLoader.shared.loadThumbnail(url: url) { thumb = $0 }
                    }
                case .failure:
                    errorMessage = "Video load failed"
                }
            }
        }
    }

    @ViewBuilder
    private var playVideoLink: some View {
        if let v = video, let url = StreamResolver.resolveVideoURL(video: v) {
            NavigationLink(destination: PlayerView(context: PlayerContext(streamURL: url, isAudioOnly: false, list: context.list, index: context.index))) {
                Text("Play")
            }
        } else {
            Button("Play") { errorMessage = "No stream" }
        }
    }

    @ViewBuilder
    private var playAudioLink: some View {
        if let v = video, let url = StreamResolver.resolveAudioURL(video: v) {
            NavigationLink(destination: PlayerView(context: PlayerContext(streamURL: url, isAudioOnly: true, list: context.list, index: context.index))) {
                Text("Audio")
            }
        } else {
            Button("Audio") { errorMessage = "No audio" }
        }
    }
}
