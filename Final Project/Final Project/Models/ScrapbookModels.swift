//
//  ScrapbookModels.swift
//  Final Project
//

import Foundation
import SwiftData

@Model
final class ScrapbookYear {
    var id: UUID
    var year: Int
    var title: String
    var coverSubtitle: String
    var coverIcon: String
    var themeName: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \JournalEntry.scrapbookYear)
    var entries: [JournalEntry] = []

    @Relationship(deleteRule: .cascade, inverse: \FavoriteItem.scrapbookYear)
    var favorites: [FavoriteItem] = []

    @Relationship(deleteRule: .cascade, inverse: \GoalItem.scrapbookYear)
    var goals: [GoalItem] = []

    @Relationship(deleteRule: .cascade, inverse: \YearHighlight.scrapbookYear)
    var highlights: [YearHighlight] = []

    @Relationship(deleteRule: .cascade, inverse: \MonthlyRecap.scrapbookYear)
    var monthlyRecaps: [MonthlyRecap] = []

    init(
        year: Int,
        title: String? = nil,
        coverSubtitle: String = "A year of little moments",
        coverIcon: String = "sparkles",
        themeName: String = "rose"
    ) {
        self.id = UUID()
        self.year = year
        self.title = title ?? "\(year)"
        self.coverSubtitle = coverSubtitle
        self.coverIcon = coverIcon
        self.themeName = themeName
        self.createdAt = Date()
    }

    var sortedEntries: [JournalEntry] {
        entries.sorted { $0.date > $1.date }
    }

    var lockedEntriesCount: Int {
        entries.filter(\.isLocked).count
    }

    var unlockedEntries: [JournalEntry] {
        entries.filter { !$0.isLocked }
    }
}

@Model
final class JournalEntry {
    var id: UUID
    var title: String
    var bodyText: String
    var date: Date
    var mood: String
    var tags: [String]
    var photoSystemNames: [String]
    var isLocked: Bool
    var createdAt: Date
    var scrapbookYear: ScrapbookYear?

    @Relationship(deleteRule: .cascade, inverse: \JournalPhoto.entry)
    var photos: [JournalPhoto] = []

    init(
        title: String,
        bodyText: String,
        date: Date,
        mood: String = "Soft",
        tags: [String] = [],
        photoSystemNames: [String] = [],
        isLocked: Bool = false
    ) {
        self.id = UUID()
        self.title = title
        self.bodyText = bodyText
        self.date = date
        self.mood = mood
        self.tags = tags
        self.photoSystemNames = photoSystemNames
        self.isLocked = isLocked
        self.createdAt = Date()
    }

    var monthName: String {
        YearbookDate.monthName(from: date)
    }

    var yearNumber: Int {
        Calendar.current.component(.year, from: date)
    }

    var searchableText: String {
        ([title, bodyText, mood] + tags).joined(separator: " ").lowercased()
    }
}

@Model
final class JournalPhoto {
    var id: UUID
    @Attribute(.externalStorage) var imageData: Data
    var createdAt: Date
    var entry: JournalEntry?

    init(imageData: Data) {
        self.id = UUID()
        self.imageData = imageData
        self.createdAt = Date()
    }
}

@Model
final class FavoriteItem {
    var id: UUID
    var title: String
    var category: String
    var note: String
    var date: Date
    var scrapbookYear: ScrapbookYear?

    init(title: String, category: String, note: String = "", date: Date = Date()) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.note = note
        self.date = date
    }
}

@Model
final class GoalItem {
    var id: UUID
    var text: String
    var isComplete: Bool
    var scrapbookYear: ScrapbookYear?

    init(text: String, isComplete: Bool = false) {
        self.id = UUID()
        self.text = text
        self.isComplete = isComplete
    }
}

@Model
final class YearHighlight {
    var id: UUID
    var title: String
    var note: String
    var date: Date
    var iconName: String
    var scrapbookYear: ScrapbookYear?

    init(title: String, note: String, date: Date = Date(), iconName: String = "heart.fill") {
        self.id = UUID()
        self.title = title
        self.note = note
        self.date = date
        self.iconName = iconName
    }
}

@Model
final class MonthlyRecap {
    var id: UUID
    var month: Int
    var summary: String
    var favoriteMoment: String
    var scrapbookYear: ScrapbookYear?

    init(month: Int, summary: String, favoriteMoment: String) {
        self.id = UUID()
        self.month = month
        self.summary = summary
        self.favoriteMoment = favoriteMoment
    }

    var monthName: String {
        YearbookDate.monthName(monthNumber: month)
    }
}
