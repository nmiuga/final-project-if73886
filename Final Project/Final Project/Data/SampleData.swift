//
//  SampleData.swift
//  Final Project
//

import Foundation
import SwiftData

enum SampleData {
    static func seedIfNeeded(modelContext: ModelContext, existingYears: [ScrapbookYear]) {
        let cleanedYears = removeOldSampleContent(modelContext: modelContext, existingYears: existingYears)

        guard cleanedYears.isEmpty else { return }

        for year in previewYears {
            modelContext.insert(year)
        }
    }

    private static func removeOldSampleContent(modelContext: ModelContext, existingYears: [ScrapbookYear]) -> [ScrapbookYear] {
        let currentYear = Calendar.current.component(.year, from: Date())
        var remainingYears: [ScrapbookYear] = []

        for scrapbookYear in existingYears {
            let isOldKeepsakeSample = scrapbookYear.year == currentYear - 1
                && scrapbookYear.title == "\(currentYear - 1) Keepsakes"

            if isOldKeepsakeSample {
                modelContext.delete(scrapbookYear)
                continue
            }

            for entry in scrapbookYear.entries where entry.title == "A private page" {
                modelContext.delete(entry)
            }

            if scrapbookYear.year == currentYear && scrapbookYear.title == "\(currentYear) Soft Launch" {
                replaceSampleFavorites(in: scrapbookYear, modelContext: modelContext)
            }

            remainingYears.append(scrapbookYear)
        }

        return remainingYears
    }

    private static func replaceSampleFavorites(in scrapbookYear: ScrapbookYear, modelContext: ModelContext) {
        for favorite in scrapbookYear.favorites {
            modelContext.delete(favorite)
        }

        let sunKissDrink = FavoriteItem(
            title: "Sun Kiss Drink",
            category: "Drink",
            note: "From Five Points Nutrition near Milledge"
        )
        let fateOfOphelia = FavoriteItem(
            title: "The Fate of Ophelia",
            category: "Song",
            note: "My favorite song so far this year by Taylor Swift even though it came out in 2025 lol"
        )

        modelContext.insert(sunKissDrink)
        modelContext.insert(fateOfOphelia)
        scrapbookYear.favorites = [sunKissDrink, fateOfOphelia]
    }

    static var previewYears: [ScrapbookYear] {
        let currentYear = Calendar.current.component(.year, from: Date())
        let thisYear = ScrapbookYear(
            year: currentYear,
            title: "\(currentYear) Soft Launch",
            coverSubtitle: "Coffee dates, tiny wins, and becoming myself",
            coverIcon: "heart.text.square.fill",
            themeName: "rose"
        )

        thisYear.entries = [
            JournalEntry(
                title: "A slow Sunday",
                bodyText: "Made pancakes, pressed flowers into a book, and wrote down three things I want to remember.",
                date: YearbookDate.date(year: currentYear, month: 2, day: 11),
                mood: "Cozy",
                tags: ["home", "weekend", "quiet"],
                photoSystemNames: ["camera.fill", "leaf.fill"]
            ),
            JournalEntry(
                title: "First picnic of the year",
                bodyText: "The blanket kept folding in the wind, but the strawberries were perfect.",
                date: YearbookDate.date(year: currentYear, month: 4, day: 15),
                mood: "Sunny",
                tags: ["friends", "spring"],
                photoSystemNames: ["sun.max.fill", "basket.fill"]
            )
        ]

        thisYear.favorites = [
            FavoriteItem(title: "Sun Kiss Drink", category: "Drink", note: "From Five Points Nutrition near Milledge"),
            FavoriteItem(
                title: "The Fate of Ophelia",
                category: "Song",
                note: "My favorite song so far this year by Taylor Swift even though it came out in 2025 lol"
            )
        ]

        thisYear.goals = [
            GoalItem(text: "Take more photos of ordinary days", isComplete: true),
            GoalItem(text: "Write one recap every month")
        ]

        thisYear.highlights = [
            YearHighlight(
                title: "Spring reset",
                note: "Cleaned my room, changed my routine, and felt lighter.",
                date: YearbookDate.date(year: currentYear, month: 3, day: 20),
                iconName: "sparkles"
            )
        ]

        thisYear.monthlyRecaps = [
            MonthlyRecap(month: 1, summary: "Soft start, lots of planning.", favoriteMoment: "New notebook day"),
            MonthlyRecap(month: 2, summary: "More rest than expected.", favoriteMoment: "Pancakes on Sunday")
        ]

        return [thisYear]
    }
}
