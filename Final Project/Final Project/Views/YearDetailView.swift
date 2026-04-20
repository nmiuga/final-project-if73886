//
//  YearDetailView.swift
//  Final Project
//

import SwiftData
import SwiftUI

struct YearDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var scrapbookYear: ScrapbookYear
    @State private var isShowingEntryEditor = false
    @State private var newFavoriteTitle = ""
    @State private var newFavoriteCategory = ""
    @State private var newFavoriteNote = ""
    @State private var newGoalText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                coverHeader
                quickStats
                recentEntries
                favorites
                goals
            }
            .padding()
        }
        .scrapbookBackground()
        .navigationTitle(scrapbookYear.yearText)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                NavigationLink {
                    YearSummaryView(scrapbookYear: scrapbookYear)
                } label: {
                    Image(systemName: "sparkles")
                }

                Button {
                    isShowingEntryEditor = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .sheet(isPresented: $isShowingEntryEditor) {
            EntryEditorView(scrapbookYear: scrapbookYear)
        }
    }

    private var coverHeader: some View {
        ScrapbookCoverCard(scrapbookYear: scrapbookYear)
    }

    private var quickStats: some View {
        HStack(spacing: 10) {
            StatPill(value: "\(scrapbookYear.entries.count)", label: "Entries", color: YearbookTheme.rose)
            StatPill(value: "\(scrapbookYear.favorites.count)", label: "Favorites", color: YearbookTheme.lavender)
            StatPill(value: "\(scrapbookYear.goals.filter(\.isComplete).count)", label: "Goals", color: YearbookTheme.sage)
        }
    }

    private var recentEntries: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "Journal", subtitle: "Newest pages first")

            if scrapbookYear.entries.isEmpty {
                EmptyStateView(title: "No journal pages yet", message: "Add a memory, mood, tags, and little photo placeholders.")
            } else {
                ForEach(scrapbookYear.sortedEntries) { entry in
                    NavigationLink {
                        EntryDetailView(entry: entry)
                    } label: {
                        JournalEntryCard(entry: entry)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var favorites: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "Favorites", subtitle: "Songs, places, clothes, meals, little obsessions")

            VStack(alignment: .leading, spacing: 10) {
                TextField("Favorite name", text: $newFavoriteTitle)
                    .textFieldStyle(.plain)

                TextField("Category, like Song or Drink", text: $newFavoriteCategory)
                    .textFieldStyle(.plain)

                TextField("Description", text: $newFavoriteNote)
                    .textFieldStyle(.plain)
                    .submitLabel(.done)
                    .onSubmit(addFavorite)

                Button(action: addFavorite) {
                    Label("Add Favorite", systemImage: "plus.circle.fill")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(YearbookTheme.rose)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .disabled(newFavoriteTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(12)
            .paperCard()

            if scrapbookYear.favorites.isEmpty {
                EmptyStateView(title: "No favorites yet", message: "Favorites can hold the tiny details that define a year.", iconName: "star")
            } else {
                ForEach(scrapbookYear.favorites) { favorite in
                    HStack(spacing: 10) {
                        NavigationLink {
                            FavoriteDetailView(favorite: favorite)
                        } label: {
                            HighlightCard(
                                iconName: "star.fill",
                                title: favorite.title,
                                note: favorite.category + (favorite.note.isEmpty ? "" : " - \(favorite.note)"),
                                color: YearbookTheme.butter
                            )
                        }
                        .buttonStyle(.plain)

                        Button(role: .destructive) {
                            deleteFavorite(favorite)
                        } label: {
                            Image(systemName: "trash.fill")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 42, height: 42)
                                .background(YearbookTheme.rose)
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Delete \(favorite.title)")
                    }
                }
            }
        }
    }

    private func addFavorite() {
        let title = newFavoriteTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        let category = newFavoriteCategory.trimmingCharacters(in: .whitespacesAndNewlines)
        let note = newFavoriteNote.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }

        let favorite = FavoriteItem(
            title: title,
            category: category.isEmpty ? "Favorite" : category,
            note: note
        )

        modelContext.insert(favorite)
        scrapbookYear.favorites.append(favorite)
        newFavoriteTitle = ""
        newFavoriteCategory = ""
        newFavoriteNote = ""
    }

    private func deleteFavorite(_ favorite: FavoriteItem) {
        scrapbookYear.favorites.removeAll { $0.id == favorite.id }
        modelContext.delete(favorite)
    }

    private var goals: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(title: "Goals", subtitle: "Soft plans and promises")

            HStack(spacing: 10) {
                TextField("Add a goal for this year", text: $newGoalText)
                    .textFieldStyle(.plain)
                    .submitLabel(.done)
                    .onSubmit(addGoal)

                Button(action: addGoal) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(YearbookTheme.rose)
                }
                .disabled(newGoalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(12)
            .paperCard()

            if scrapbookYear.goals.isEmpty {
                EmptyStateView(title: "No goals yet", message: "Add one tiny promise to future you.", iconName: "checkmark.circle")
            }

            ForEach(scrapbookYear.goals) { goal in
                HStack {
                    Button {
                        goal.isComplete.toggle()
                    } label: {
                        Image(systemName: goal.isComplete ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(goal.isComplete ? YearbookTheme.sage : Color.secondary)
                    }
                    .buttonStyle(.plain)

                    Text(goal.text)
                        .foregroundStyle(YearbookTheme.ink)
                        .strikethrough(goal.isComplete, color: YearbookTheme.sage)

                    Spacer()

                    Button(role: .destructive) {
                        deleteGoal(goal)
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(YearbookTheme.rose)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Delete \(goal.text)")
                }
                .padding(12)
                .paperCard()
            }
        }
    }

    private func addGoal() {
        let trimmedGoal = newGoalText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedGoal.isEmpty else { return }

        let goal = GoalItem(text: trimmedGoal)
        modelContext.insert(goal)
        scrapbookYear.goals.append(goal)
        newGoalText = ""
    }

    private func deleteGoal(_ goal: GoalItem) {
        scrapbookYear.goals.removeAll { $0.id == goal.id }
        modelContext.delete(goal)
    }
}

struct StatPill: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.bold())
            Text(label)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(color)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.13))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct YearDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            YearDetailView(scrapbookYear: SampleData.previewYears[0])
        }
    }
}
