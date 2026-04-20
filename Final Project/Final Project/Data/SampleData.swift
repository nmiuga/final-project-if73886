//
//  SampleData.swift
//  Final Project
//

import Foundation
import SwiftData
import UIKit

enum SampleData {
    private static let celebrationSubtitle = "Graduation, Celebrations and Spending Precious Time with my Friends"

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
            let commaFormattedYear = NumberFormatter.localizedString(from: NSNumber(value: scrapbookYear.year), number: .decimal)

            if scrapbookYear.title == commaFormattedYear {
                scrapbookYear.title = scrapbookYear.yearText
            }

            let isOldKeepsakeSample = scrapbookYear.year == currentYear - 1
                && scrapbookYear.title == "\(currentYear - 1) Keepsakes"

            if isOldKeepsakeSample {
                modelContext.delete(scrapbookYear)
                continue
            }

            for entry in scrapbookYear.entries where entry.title == "A private page" {
                modelContext.delete(entry)
            }

            if scrapbookYear.year == currentYear && (scrapbookYear.title == "\(currentYear) Soft Launch" || scrapbookYear.title == "\(currentYear): Celebration Year" || scrapbookYear.title == "Celebration Year") {
                scrapbookYear.title = "Celebration Year"
                scrapbookYear.coverSubtitle = celebrationSubtitle
                scrapbookYear.themeName = "blue"
                replaceBelizeSampleEntry(in: scrapbookYear, modelContext: modelContext)
                replaceGraduationSampleEntry(in: scrapbookYear, modelContext: modelContext)
                replaceSampleFavorites(in: scrapbookYear, modelContext: modelContext)
            }

            remainingYears.append(scrapbookYear)
        }

        return remainingYears
    }

    private static func replaceBelizeSampleEntry(in scrapbookYear: ScrapbookYear, modelContext: ModelContext) {
        let currentYear = Calendar.current.component(.year, from: Date())
        let belizeEntry = makeBelizeAdventureEntry(year: currentYear)

        if let index = scrapbookYear.entries.firstIndex(where: { $0.title == "A slow Sunday" || $0.title == "Belize adventure" }) {
            let existingEntry = scrapbookYear.entries[index]
            existingEntry.title = belizeEntry.title
            existingEntry.bodyText = belizeEntry.bodyText
            existingEntry.date = belizeEntry.date
            existingEntry.mood = belizeEntry.mood
            existingEntry.tags = belizeEntry.tags
            existingEntry.photoSystemNames = belizeEntry.photoSystemNames

            for photo in existingEntry.photos {
                modelContext.delete(photo)
            }

            for photo in belizeEntry.photos {
                modelContext.insert(photo)
                photo.entry = existingEntry
            }

            existingEntry.photos = belizeEntry.photos
        } else {
            modelContext.insert(belizeEntry)
            scrapbookYear.entries.append(belizeEntry)
        }
    }

    private static func replaceGraduationSampleEntry(in scrapbookYear: ScrapbookYear, modelContext: ModelContext) {
        let currentYear = Calendar.current.component(.year, from: Date())
        let graduationEntry = makeGraduationPhotoEntry(year: currentYear)

        if let index = scrapbookYear.entries.firstIndex(where: { $0.title == "First picnic of the year" || $0.title == "Graduation photos" }) {
            let existingEntry = scrapbookYear.entries[index]
            existingEntry.title = graduationEntry.title
            existingEntry.bodyText = graduationEntry.bodyText
            existingEntry.date = graduationEntry.date
            existingEntry.mood = graduationEntry.mood
            existingEntry.tags = graduationEntry.tags
            existingEntry.photoSystemNames = graduationEntry.photoSystemNames

            for photo in existingEntry.photos {
                modelContext.delete(photo)
            }

            for photo in graduationEntry.photos {
                modelContext.insert(photo)
                photo.entry = existingEntry
            }

            existingEntry.photos = graduationEntry.photos
        } else {
            modelContext.insert(graduationEntry)
            scrapbookYear.entries.append(graduationEntry)
        }
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
            title: "Celebration Year",
            coverSubtitle: celebrationSubtitle,
            coverIcon: "heart.text.square.fill",
            themeName: "blue"
        )

        thisYear.entries = [
            makeBelizeAdventureEntry(year: currentYear),
            makeGraduationPhotoEntry(year: currentYear)
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

    private static func makeBelizeAdventureEntry(year: Int) -> JournalEntry {
        let entry = JournalEntry(
            title: "Belize adventure",
            bodyText: "We stopped in Belize today! We got on a bus and went cave tubing and cliff jumping! It was so relaxing, and just overall, such a good time!",
            date: YearbookDate.date(year: year, month: 3, day: 10),
            mood: "Relaxed",
            tags: ["belize", "travel", "adventure"],
            photoSystemNames: ["water.waves", "figure.pool.swim"]
        )

        if let imageData = bundledImageData(named: "IMG_6634") {
            let photo = JournalPhoto(imageData: imageData)
            photo.entry = entry
            entry.photos = [photo]
        }

        return entry
    }

    private static func makeGraduationPhotoEntry(year: Int) -> JournalEntry {
        let entry = JournalEntry(
            title: "Graduation photos",
            bodyText: "Today my friends and I took graduation photos!! After, we went to get ice cream is was such a fun day to celebrate with my friends!!",
            date: YearbookDate.date(year: year, month: 3, day: 22),
            mood: "Joyful",
            tags: ["graduation", "friends", "photos"],
            photoSystemNames: ["camera.fill"]
        )

        if let imageData = bundledImageData(named: "graduation-photos") {
            let photo = JournalPhoto(imageData: imageData)
            photo.entry = entry
            entry.photos = [photo]
        }

        return entry
    }

    private static func bundledImageData(named name: String) -> Data? {
        if let imageURL = Bundle.main.url(forResource: name, withExtension: "jpeg") {
            return try? Data(contentsOf: imageURL)
        }

        return UIImage(named: name)?.jpegData(compressionQuality: 0.9)
    }
}
