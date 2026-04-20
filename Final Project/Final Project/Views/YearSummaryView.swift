//
//  YearSummaryView.swift
//  Final Project
//

import SwiftUI

struct YearSummaryView: View {
    let scrapbookYear: ScrapbookYear

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SectionTitle(title: "\(scrapbookYear.yearText) Highlights", subtitle: "A little summary page for the year")

                HighlightCard(
                    iconName: "book.pages.fill",
                    title: "\(scrapbookYear.entries.count) journal pages",
                    note: mostCommonMoodText,
                    color: YearbookTheme.rose
                )

                if !scrapbookYear.highlights.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        SectionTitle(title: "Big Little Moments")

                        ForEach(scrapbookYear.highlights) { highlight in
                            HighlightCard(
                                iconName: highlight.iconName,
                                title: highlight.title,
                                note: highlight.note,
                                color: YearbookTheme.lavender
                            )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(title: "Monthly Recaps")

                    if scrapbookYear.monthlyRecaps.isEmpty {
                        EmptyStateView(title: "No recaps yet", message: "Monthly summaries can be added later from this model.", iconName: "calendar")
                    } else {
                        ForEach(scrapbookYear.monthlyRecaps.sorted { $0.month < $1.month }) { recap in
                            HighlightCard(
                                iconName: "calendar",
                                title: recap.monthName,
                                note: "\(recap.summary) Favorite: \(recap.favoriteMoment)",
                                color: YearbookTheme.sage
                            )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(title: "Favorite Things")

                    ForEach(scrapbookYear.favorites) { favorite in
                        NavigationLink {
                            FavoriteDetailView(favorite: favorite)
                        } label: {
                            HighlightCard(
                                iconName: "heart.fill",
                                title: favorite.title,
                                note: favorite.category,
                                color: YearbookTheme.butter
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .scrapbookBackground()
        .navigationTitle("Summary")
    }

    private var mostCommonMoodText: String {
        let moods = scrapbookYear.entries.map(\.mood)
        let grouped = Dictionary(grouping: moods, by: { $0 })
        let topMood = grouped.max { $0.value.count < $1.value.count }?.key
        return topMood == nil ? "Start journaling to discover the mood of this year." : "Most common mood: \(topMood!)"
    }
}

struct YearSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            YearSummaryView(scrapbookYear: SampleData.previewYears[0])
        }
    }
}
