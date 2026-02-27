//
//  ContentView.swift
//  YouTooOld Watch App
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SearchRootView()) {
                    Label("Search", systemImage: "magnifyingglass")
                }
                NavigationLink(destination: VideoListView(context: VideoListContext(mode: .trending, query: nil))) {
                    Label("Trending", systemImage: "chart.line.uptrend.xyaxis")
                }
                NavigationLink(destination: VideoListView(context: VideoListContext(mode: .popular, query: nil))) {
                    Label("Popular", systemImage: "play.rectangle.fill")
                }
                NavigationLink(destination: SettingsView()) {
                    Label("Settings", systemImage: "gear")
                }
            }
            .navigationTitle("YouTooOld")
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
