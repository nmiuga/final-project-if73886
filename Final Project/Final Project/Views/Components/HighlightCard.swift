//
//  HighlightCard.swift
//  Final Project
//

import SwiftUI

struct HighlightCard: View {
    let iconName: String
    let title: String
    let note: String
    var color: Color = YearbookTheme.rose

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(YearbookTheme.ink)

                Text(note)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(12)
        .paperCard()
    }
}

struct HighlightCard_Previews: PreviewProvider {
    static var previews: some View {
        HighlightCard(iconName: "sparkles", title: "Spring reset", note: "A tiny fresh start.")
            .padding()
            .scrapbookBackground()
    }
}
