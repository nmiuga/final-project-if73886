//
//  TimelineView.swift
//  Final Project
//

import SwiftData
import SwiftUI

struct TimelineView: View {
    @Query(sort: \ScrapbookYear.year, order: .reverse) private var scrapbookYears: [ScrapbookYear]

    private var entries: [JournalEntry] {
        scrapbookYears
            .flatMap(\.entries)
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    SectionTitle(title: "Memory Feed", subtitle: "A timeline across every year")

                    if entries.isEmpty {
                        EmptyStateView(title: "No timeline yet", message: "Journal pages will appear here once you add them.", iconName: "clock")
                    } else {
                        ForEach(entries) { entry in
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
            .navigationTitle("Timeline")
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
