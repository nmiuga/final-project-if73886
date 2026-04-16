//
//  ContentView.swift
//  Final Project
//
//  Created by Isabel Finnerty on 4/13/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScrapbookYear.year, order: .reverse) private var scrapbookYears: [ScrapbookYear]

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Years", systemImage: "book.closed.fill")
                }

            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage: "clock.fill")
                }

            OnThisDayView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
        .tint(YearbookTheme.rose)
        .task {
            SampleData.seedIfNeeded(modelContext: modelContext, existingYears: scrapbookYears)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: [
                ScrapbookYear.self,
                JournalEntry.self,
                JournalPhoto.self,
                FavoriteItem.self,
                GoalItem.self,
                YearHighlight.self,
                MonthlyRecap.self
            ], inMemory: true)
    }
}
