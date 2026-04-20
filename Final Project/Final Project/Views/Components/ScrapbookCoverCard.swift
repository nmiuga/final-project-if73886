//
//  ScrapbookCoverCard.swift
//  Final Project
//

import SwiftUI

struct ScrapbookCoverCard: View {
    let scrapbookYear: ScrapbookYear

    var body: some View {
        let theme = YearbookTheme.rose

        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(theme.opacity(0.26))
                .offset(x: 8, y: 8)

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: scrapbookYear.coverIcon)
                        .font(.title2)
                        .foregroundStyle(theme)
                        .frame(width: 44, height: 44)
                        .background(.white.opacity(0.75))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    Spacer()

                    Text("\(scrapbookYear.entries.count) memories")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(theme)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(verbatim: scrapbookYear.title)
                        .font(.title2.bold())
                        .foregroundStyle(YearbookTheme.ink)
                        .lineLimit(2)

                    Text(scrapbookYear.coverSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 8) {
                    TagChip(text: scrapbookYear.yearText, color: theme)
                    if scrapbookYear.lockedEntriesCount > 0 {
                        TagChip(text: "\(scrapbookYear.lockedEntriesCount) private", color: YearbookTheme.lavender)
                    }
                }
            }
            .padding(16)
            .paperCard()
        }
    }
}

struct ScrapbookCoverCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrapbookCoverCard(scrapbookYear: SampleData.previewYears[0])
            .padding()
            .scrapbookBackground()
    }
}
