//
//  EmptyStateView.swift
//  Final Project
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    var iconName = "heart.text.square"

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundStyle(YearbookTheme.rose)

            Text(title)
                .font(.headline)
                .foregroundStyle(YearbookTheme.ink)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(YearbookTheme.blush.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView(title: "No memories yet", message: "Add a journal entry to begin this scrapbook.")
            .padding()
            .scrapbookBackground()
    }
}
