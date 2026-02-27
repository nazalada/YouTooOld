//
//  VideoListView.swift
//  YouTooOld Watch App
//

import SwiftUI

struct VideoListView: View {
    let context: VideoListContext
    @State private var videos: [VideoModel] = []
    @State private var loading = false
    @State private var errorMessage: String?
    @State private var page = 0
    private let maxRows = 10

    var body: some View {
        Group {
            if let msg = errorMessage {
                Text(msg).foregroundStyle(.secondary)
            } else {
                List {
                    ForEach(Array(displayVideos.enumerated()), id: \.element.videoId) { index, video in
                        NavigationLink(destination: detailDestination(for: video, at: index)) {
                            VideoRowView(video: video)
                        }
                    }
                    if loading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                    if !videos.isEmpty && page >= 0 {
                        Button("Load more") {
                            loadPage(page + 1)
                        }
                        .disabled(loading)
                    }
                }
            }
        }
        .navigationTitle(listTitle)
        .task {
            MemoryManagerSwift.shared.checkMemoryAndCleanupIfNeeded()
            if videos.isEmpty { loadPage(0) }
        }
    }

    private var displayVideos: [VideoModel] {
        Array(videos.prefix(maxRows))
    }

    private var listTitle: String {
        switch context.mode {
        case .trending: return "Trending"
        case .popular: return "Popular"
        case .search: return context.query ?? "Search"
        }
    }

    private func detailDestination(for video: VideoModel, at index: Int) -> VideoDetailView {
        VideoDetailView(context: VideoDetailContext(videoId: video.videoId, list: videos, index: index))
    }

    private func loadPage(_ p: Int) {
        loading = true
        errorMessage = nil
        InvidiousAPI.shared.fetchList(context: context, page: p) { result in
            DispatchQueue.main.async {
                loading = false
                switch result {
                case .success(let list):
                    if p == 0 { videos = list }
                    else { videos.append(contentsOf: list) }
                    page = p
                case .failure:
                    errorMessage = "Load failed"
                }
            }
        }
    }
}
