//
//  EntryDetailView.swift
//  Final Project
//

import SwiftData
import SwiftUI
import UIKit

struct EntryDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var entry: JournalEntry
    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    TagChip(text: entry.mood, color: YearbookTheme.rose)
                    TagChip(text: YearbookDate.displayDate.string(from: entry.date), color: YearbookTheme.lavender)
                    if entry.isLocked {
                        TagChip(text: "Private", color: YearbookTheme.sage)
                    }
                }

                Text(entry.title)
                    .font(.largeTitle.bold())
                    .foregroundStyle(YearbookTheme.ink)

                Text(entry.isLocked ? "This page is locked. In a full app, Face ID or a passcode can unlock it." : entry.bodyText)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .lineSpacing(5)

                if !entry.tags.isEmpty {
                    FlowTags(tags: entry.tags)
                }

                if !entry.photos.isEmpty || !entry.photoSystemNames.isEmpty {
                    SectionTitle(title: "Photos")

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        if entry.photos.isEmpty {
                            ForEach(entry.photoSystemNames, id: \.self) { icon in
                                Image(systemName: icon)
                                    .font(.largeTitle)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, minHeight: 120)
                                    .background(YearbookTheme.blush)
                                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            }
                        } else {
                            ForEach(entry.photos) { photo in
                                if let uiImage = UIImage(data: photo.imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, minHeight: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .scrapbookBackground()
        .navigationTitle("Memory")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Edit") {
                    isEditing = true
                }

                Button(role: .destructive) {
                    modelContext.delete(entry)
                    dismiss()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            if let scrapbookYear = entry.scrapbookYear {
                EntryEditorView(scrapbookYear: scrapbookYear, entryToEdit: entry)
            }
        }
    }
}

struct FlowTags: View {
    let tags: [String]

    var body: some View {
        HStack {
            ForEach(tags, id: \.self) { tag in
                TagChip(text: tag, color: YearbookTheme.sage)
            }
        }
    }
}

struct EntryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EntryDetailView(entry: SampleData.previewYears[0].entries[0])
        }
    }
}
