//
//  SearchView.swift
//  Final Project
//

import SwiftData
import SwiftUI

struct SearchView: View {
    @Query(sort: \ScrapbookYear.year, order: .reverse) private var scrapbookYears: [ScrapbookYear]
    @StateObject private var viewModel = SearchViewModel()

    private var results: [JournalEntry] {
        viewModel.filteredEntries(from: scrapbookYears)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    filters

                    SectionTitle(title: "Results", subtitle: "\(results.count) matching memories")

                    if results.isEmpty {
                        EmptyStateView(title: "No matches", message: "Try a different keyword, tag, month, or year.", iconName: "magnifyingglass")
                    } else {
                        ForEach(results) { entry in
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
            .navigationTitle("Search")
            .toolbar {
                Button("Reset") {
                    viewModel.resetFilters()
                }
            }
        }
    }

    private var filters: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Keyword, mood, or memory", text: $viewModel.keyword)
                .textFieldStyle(.roundedBorder)

            Picker("Tag", selection: $viewModel.selectedTag) {
                Text("Any tag").tag("")
                ForEach(viewModel.availableTags(from: scrapbookYears), id: \.self) { tag in
                    Text(tag).tag(tag)
                }
            }

            Picker("Month", selection: $viewModel.selectedMonth) {
                Text("Any month").tag(0)
                ForEach(1...12, id: \.self) { month in
                    Text(YearbookDate.monthName(monthNumber: month)).tag(month)
                }
            }

            Picker("Year", selection: $viewModel.selectedYear) {
                Text("Any year").tag(0)
                ForEach(scrapbookYears.map(\.year), id: \.self) { year in
                    Text("\(year)").tag(year)
                }
            }
        }
        .padding(14)
        .paperCard()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
