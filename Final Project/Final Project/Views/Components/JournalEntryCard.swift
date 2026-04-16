//
//  JournalEntryCard.swift
//  Final Project
//

import SwiftUI
import UIKit

struct JournalEntryCard: View {
    let entry: JournalEntry
    var showYear = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.title)
                        .font(.headline)
                        .foregroundStyle(YearbookTheme.ink)

                    Text(dateText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if entry.isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(YearbookTheme.lavender)
                }
            }

            Text(entry.isLocked ? "This page is private." : entry.bodyText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            if !entry.photos.isEmpty {
                HStack(spacing: 8) {
                    ForEach(entry.photos.prefix(3)) { photo in
                        if let uiImage = UIImage(data: photo.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                    }
                }
            } else if !entry.photoSystemNames.isEmpty {
                HStack(spacing: 8) {
                    ForEach(entry.photoSystemNames.prefix(3), id: \.self) { systemName in
                        Image(systemName: systemName)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(YearbookTheme.blush)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }
            }

            HStack {
                TagChip(text: entry.mood, color: YearbookTheme.rose)

                ForEach(entry.tags.prefix(2), id: \.self) { tag in
                    TagChip(text: tag, color: YearbookTheme.sage)
                }
            }
        }
        .padding(14)
        .paperCard()
    }

    private var dateText: String {
        let base = YearbookDate.displayDate.string(from: entry.date)
        guard showYear, let year = entry.scrapbookYear?.year else { return base }
        return "\(base) in \(year)"
    }
}

struct JournalEntryCard_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryCard(entry: SampleData.previewYears[0].entries[0])
            .padding()
            .scrapbookBackground()
    }
}
