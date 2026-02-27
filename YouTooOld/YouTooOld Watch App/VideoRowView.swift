//
//  VideoRowView.swift
//  YouTooOld Watch App
//

import SwiftUI

struct VideoRowView: View {
    let video: VideoModel
    @State private var thumb: UIImage?

    var body: some View {
        HStack(spacing: 8) {
            thumbnailView
            VStack(alignment: .leading, spacing: 2) {
                Text(video.title)
                    .lineLimit(2)
                    .font(.caption)
                Text(video.author)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .task(id: video.thumbnailURL) {
            guard let url = video.thumbnailURL else { return }
            ThumbnailLoader.shared.loadThumbnail(url: url) { thumb = $0 }
        }
    }

    @ViewBuilder
    private var thumbnailView: some View {
        if let img = thumb {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 52, height: 30)
                .clipped()
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 52, height: 30)
        }
    }
}
