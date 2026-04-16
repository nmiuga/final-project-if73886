//
//  OnThisDayView.swift
//  Final Project
//

import SwiftData
import SwiftUI

struct OnThisDayView: View {
    @Query(sort: \ScrapbookYear.year, order: .reverse) private var scrapbookYears: [ScrapbookYear]

    private var memories: [JournalEntry] {
        scrapbookYears
            .flatMap(\.entries)
            .filter { YearbookDate.isOnThisDay($0.date) }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionTitle(title: "On This Day", subtitle: "Memories from this calendar date")

                    if memories.isEmpty {
                        EmptyStateView(
                            title: "No matching memories",
                            message: "When a journal page shares today's month and day, it will glow here.",
                            iconName: "calendar.badge.clock"
                        )
                    } else {
                        ForEach(memories) { entry in
                            NavigationLink {
                                EntryDetailView(entry: entry)
                            } label: {
                                JournalEntryCard(entry: entry, showYear: true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .scrapbookBackground()
            .navigationTitle("Today")
        }
    }
}

struct OnThisDayView_Previews: PreviewProvider {
    static var previews: some View {
        OnThisDayView()
    }
}
