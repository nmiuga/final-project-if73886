//
//  Final_ProjectApp.swift
//  Final Project
//
//  Created by Isabel Finnerty on 4/13/26.
//

import SwiftUI
import SwiftData

@main
struct Final_ProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            ScrapbookYear.self,
            JournalEntry.self,
            JournalPhoto.self,
            FavoriteItem.self,
            GoalItem.self,
            YearHighlight.self,
            MonthlyRecap.self
        ])
    }
}
