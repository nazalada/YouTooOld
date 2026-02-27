//
//  ContentView.swift
//  YouTooOld (iOS)
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "applewatch")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("YouTooOld")
                .font(.title2)
            Text("Use the Watch app to browse and play.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
