//
//  VideoListController.swift
//  YouTooOld WatchKit Extension
//

import WatchKit
import Foundation

final class VideoListController: WKInterfaceController {

    @IBOutlet private weak var table: WKInterfaceTable!
    @IBOutlet private weak var loadMoreButton: WKInterfaceButton!

    private var context: VideoListContext?
    private var videos: [VideoModel] = []
    private var currentPage: Int = 0
    private let maxRowsInMemory = 10

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.context = context as? VideoListContext
    }

    override func willActivate() {
        super.willActivate()
        MemoryManager.shared.checkMemoryAndCleanupIfNeeded()
        loadContentIfNeeded()
    }

    private func loadContentIfNeeded() {
        guard let ctx = context else { return }
        if videos.isEmpty {
            fetchVideos(context: ctx, page: 0)
        }
    }

    private func fetchVideos(context: VideoListContext, page: Int) {
        loadMoreButton.setEnabled(false)
        let queue = DispatchQueue.global(qos: .userInitiated)
        queue.async { [weak self] in
            InvidiousAPI.shared.fetchList(context: context, page: page) { result in
                DispatchQueue.main.async {
                    self?.loadMoreButton.setEnabled(true)
                    switch result {
                    case .success(let list):
                        if page == 0 { self?.videos = list }
                        else { self?.videos.append(contentsOf: list) }
                        self?.currentPage = page
                        self?.reloadTable()
                    case .failure:
                        self?.showError("Load failed")
                    }
                }
            }
        }
    }

    private func reloadTable() {
        let count = min(videos.count, maxRowsInMemory)
        table.setNumberOfRows(count, withRowType: "VideoRowController")
        for i in 0..<count {
            guard let row = table.rowController(at: i) as? VideoRowController else { continue }
            row.configure(with: videos[i])
        }
    }

    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard rowIndex < videos.count else { return }
        let video = videos[rowIndex]
        pushController(withName: "VideoDetailController", context: VideoDetailContext(videoId: video.videoId, list: videos, index: rowIndex))
    }

    @IBAction func loadMoreTapped() {
        guard let ctx = context else { return }
        fetchVideos(context: ctx, page: currentPage + 1)
    }

    private func showError(_ message: String) {
        // Could set a label or present alert
    }
}

struct VideoDetailContext {
    let videoId: String
    let list: [VideoModel]
    let index: Int
}
