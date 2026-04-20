//
//  YearbookHomeViewModel.swift
//  Final Project
//

import Combine
import Foundation
import SwiftData

@MainActor
final class YearbookHomeViewModel: ObservableObject {
    @Published var newYearText = ""
    @Published var newYearTitle = ""
    @Published var selectedThemeName = "blue"

    let themeNames = YearbookTheme.colorSchemeNames

    func createYear(modelContext: ModelContext) {
        let trimmedYear = newYearText.trimmingCharacters(in: .whitespacesAndNewlines)
        let year = Int(trimmedYear) ?? Calendar.current.component(.year, from: Date())
        let trimmedTitle = newYearTitle.trimmingCharacters(in: .whitespacesAndNewlines)

        let scrapbookYear = ScrapbookYear(
            year: year,
            title: trimmedTitle.isEmpty ? "\(year)" : trimmedTitle,
            coverSubtitle: "A scrapbook for every version of me",
            coverIcon: "sparkles",
            themeName: selectedThemeName
        )

        modelContext.insert(scrapbookYear)
        resetDraft()
    }

    func deleteYears(_ years: [ScrapbookYear], offsets: IndexSet, modelContext: ModelContext) {
        for index in offsets {
            modelContext.delete(years[index])
        }
    }

    private func resetDraft() {
        newYearText = ""
        newYearTitle = ""
        selectedThemeName = "blue"
    }
}
