//
//  SettingsView.swift
//  YouTooOld Watch App
//

import SwiftUI

struct SettingsView: View {
    @State private var qualityIndex: Int
    @State private var instanceIndex: Int
    @State private var memoryMB: Int = 0

    private static let qualityOptions: [(String, VideoQuality)] = [
        ("144p", .p144),
        ("240p", .p240),
        ("360p", .p360)
    ]

    init() {
        let q = SettingsManager.shared.videoQuality
        let idx = Self.qualityOptions.firstIndex(where: { $0.1 == q }) ?? 2
        _qualityIndex = State(initialValue: idx)
        _instanceIndex = State(initialValue: InstanceManager.shared.currentIndex)
    }

    var body: some View {
        List {
            Section("Quality") {
                Picker("Quality", selection: $qualityIndex) {
                    ForEach(Array(Self.qualityOptions.enumerated()), id: \.offset) { i, item in
                        Text(item.0).tag(i)
                    }
                }
                .onChange(of: qualityIndex) { new in
                    guard new >= 0, new < Self.qualityOptions.count else { return }
                    SettingsManager.shared.videoQuality = Self.qualityOptions[new].1
                }
            }
            Section("Instance") {
                Picker("Instance", selection: $instanceIndex) {
                    ForEach(Array(InstanceManager.shared.instanceURLs.enumerated()), id: \.offset) { i, url in
                        Text(URL(string: url)?.host ?? url).tag(i)
                    }
                }
                .onChange(of: instanceIndex) { new in
                    InstanceManager.shared.selectInstance(at: new)
                }
            }
            Section("Memory") {
                Text("Memory: \(memoryMB) MB")
                Button("Clear cache") {
                    ThumbnailLoader.shared.purge()
                    memoryMB = MemoryManagerSwift.shared.availableMemoryMB()
                }
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            memoryMB = MemoryManagerSwift.shared.availableMemoryMB()
        }
    }
}
