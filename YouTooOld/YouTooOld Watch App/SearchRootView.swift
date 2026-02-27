//
//  SearchRootView.swift
//  YouTooOld Watch App
//

import SwiftUI

struct SearchRootView: View {
    @State private var query = ""
    @State private var committedQuery: String?
    @FocusState private var focused: Bool

    var body: some View {
        Group {
            if let q = committedQuery, !q.isEmpty {
                VideoListView(context: VideoListContext(mode: .search, query: q))
            } else {
                TextField("Search", text: $query)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        let t = query.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !t.isEmpty { committedQuery = t }
                    }
                if !query.isEmpty {
                    Button("Search") {
                        let t = query.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !t.isEmpty { committedQuery = t }
                    }
                }
            }
        }
        .navigationTitle("Search")
    }
}
