//
//  YearbookDate.swift
//  Final Project
//

import Foundation

enum YearbookDate {
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static func date(year: Int, month: Int, day: Int) -> Date {
        Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }

    static func monthName(from date: Date) -> String {
        let month = Calendar.current.component(.month, from: date)
        return monthName(monthNumber: month)
    }

    static func monthName(monthNumber: Int) -> String {
        let formatter = DateFormatter()
        return formatter.monthSymbols[max(0, min(monthNumber - 1, 11))]
    }

    static func isOnThisDay(_ date: Date, comparedTo comparisonDate: Date = Date()) -> Bool {
        let calendar = Calendar.current
        return calendar.component(.month, from: date) == calendar.component(.month, from: comparisonDate)
            && calendar.component(.day, from: date) == calendar.component(.day, from: comparisonDate)
    }
}
