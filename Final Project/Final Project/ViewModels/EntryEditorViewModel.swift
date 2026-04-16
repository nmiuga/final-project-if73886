//
//  EntryEditorViewModel.swift
//  Final Project
//

import Combine
import Foundation

@MainActor
final class EntryEditorViewModel: ObservableObject {
    @Published var title = ""
    @Published var bodyText = ""
    @Published var date = Date()
    @Published var mood = "Cozy"
    @Published var tagsText = ""

    let moodOptions = ["Cozy", "Joyful", "Tender", "Proud", "Calm", "Sparkly", "Bittersweet"]

    init(entry: JournalEntry? = nil) {
        guard let entry else { return }
        title = entry.title
        bodyText = entry.bodyText
        date = entry.date
        mood = entry.mood
        tagsText = entry.tags.joined(separator: ", ")
    }

    func makeEntry() -> JournalEntry {
        JournalEntry(
            title: title.isEmpty ? "Untitled memory" : title,
            bodyText: bodyText,
            date: date,
            mood: mood,
            tags: parsedTags,
            photoSystemNames: ["photo.fill"]
        )
    }

    func update(_ entry: JournalEntry) {
        entry.title = title.isEmpty ? "Untitled memory" : title
        entry.bodyText = bodyText
        entry.date = date
        entry.mood = mood
        entry.tags = parsedTags
        entry.isLocked = false
    }

    private var parsedTags: [String] {
        tagsText
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
