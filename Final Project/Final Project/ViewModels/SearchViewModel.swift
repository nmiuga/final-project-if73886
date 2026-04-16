//
//  SearchViewModel.swift
//  Final Project
//

import Combine
import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var keyword = ""
    @Published var selectedTag = ""
    @Published var selectedMonth = 0
    @Published var selectedYear = 0

    func filteredEntries(from years: [ScrapbookYear]) -> [JournalEntry] {
        let keyword = keyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let tag = selectedTag.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        return years
            .flatMap(\.entries)
            .filter { entry in
                let matchesKeyword = keyword.isEmpty || entry.searchableText.contains(keyword)
                let matchesTag = tag.isEmpty || entry.tags.map { $0.lowercased() }.contains(tag)
                let matchesMonth = selectedMonth == 0 || Calendar.current.component(.month, from: entry.date) == selectedMonth
                let matchesYear = selectedYear == 0 || entry.yearNumber == selectedYear
                return matchesKeyword && matchesTag && matchesMonth && matchesYear
            }
            .sorted { $0.date > $1.date }
    }

    func availableTags(from years: [ScrapbookYear]) -> [String] {
        let tags = years.flatMap(\.entries).flatMap(\.tags)
        return Array(Set(tags)).sorted()
    }

    func resetFilters() {
        keyword = ""
        selectedTag = ""
        selectedMonth = 0
        selectedYear = 0
    }
}
