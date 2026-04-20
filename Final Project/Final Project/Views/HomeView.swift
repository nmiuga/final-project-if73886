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
    @State private var isShowingColorPicker = false
    @AppStorage(YearbookTheme.colorSchemeKey) private var selectedColorScheme = "blue"

    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("My Year Scrapbook")
                            .font(.largeTitle.bold())
                            .foregroundStyle(YearbookTheme.ink)

                        Text("A  place for memories, favorite things, goals, highlights, and monthly recaps.")
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
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isShowingColorPicker = true
                    } label: {
                        Image(systemName: "paintpalette.fill")
                    }
                    .accessibilityLabel("Change color scheme")
                }

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
            .sheet(isPresented: $isShowingColorPicker) {
                ColorSchemePickerView(selectedColorScheme: $selectedColorScheme)
            }
        }
    }
}

struct ColorSchemePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedColorScheme: String

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(YearbookTheme.colorSchemeNames, id: \.self) { colorName in
                        Button {
                            selectedColorScheme = colorName
                        } label: {
                            VStack(spacing: 10) {
                                Circle()
                                    .fill(YearbookTheme.color(for: colorName))
                                    .frame(width: 48, height: 48)
                                    .overlay {
                                        if selectedColorScheme == colorName {
                                            Image(systemName: "checkmark")
                                                .font(.headline.bold())
                                                .foregroundStyle(.white)
                                        }
                                    }

                                Text(colorName.capitalized)
                                    .font(.headline)
                                    .foregroundStyle(YearbookTheme.ink)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                YearbookTheme.color(for: colorName).opacity(selectedColorScheme == colorName ? 0.18 : 0.08)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .scrapbookBackground()
            .navigationTitle("Color Scheme")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
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
                    TextField("Title, like My AdventurousYear", text: $viewModel.newYearTitle)
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
