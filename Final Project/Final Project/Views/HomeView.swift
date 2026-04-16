//
//  HomeView.swift
//  Final Project
//

import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScrapbookYear.year, order: .reverse) private var scrapbookYears: [ScrapbookYear]
    @StateObject private var viewModel = YearbookHomeViewModel()
    @State private var isShowingNewYear = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("My Year Scrapbook")
                            .font(.largeTitle.bold())
                            .foregroundStyle(YearbookTheme.ink)

                        Text("A soft place for memories, favorite things, goals, highlights, and monthly recaps.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
                }

                if scrapbookYears.isEmpty {
                    EmptyStateView(
                        title: "Start your first year",
                        message: "Create a scrapbook cover, then fill it with journal pages and keepsakes.",
                        iconName: "book.closed"
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                } else {
                    Section {
                        ForEach(scrapbookYears) { scrapbookYear in
                            NavigationLink {
                                YearDetailView(scrapbookYear: scrapbookYear)
                            } label: {
                                ScrapbookCoverCard(scrapbookYear: scrapbookYear)
                                    .padding(.vertical, 8)
                            }
                            .buttonStyle(.plain)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                        }
                        .onDelete { offsets in
                            viewModel.deleteYears(scrapbookYears, offsets: offsets, modelContext: modelContext)
                        }
                    } header: {
                        Text("Scrapbook Covers")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .scrapbookBackground()
            .navigationTitle("Yearbook")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingNewYear = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingNewYear) {
                NewYearView(viewModel: viewModel)
            }
        }
    }
}

struct NewYearView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: YearbookHomeViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Cover") {
                    TextField("Year, like 2026", text: $viewModel.newYearText)
                        .keyboardType(.numberPad)
                    TextField("Title, like My Softest Year", text: $viewModel.newYearTitle)
                }

                Section("Theme") {
                    Picker("Theme", selection: $viewModel.selectedThemeName) {
                        ForEach(viewModel.themeNames, id: \.self) { themeName in
                            Text(themeName.capitalized).tag(themeName)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("New Scrapbook")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.createYear(modelContext: modelContext)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
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
