//
//  EntryEditorView.swift
//  Final Project
//

import PhotosUI
import SwiftUI
import UIKit

struct EntryEditorView: View {
    @Environment(\.dismiss) private var dismiss
    let scrapbookYear: ScrapbookYear
    var entryToEdit: JournalEntry?
    @StateObject private var viewModel: EntryEditorViewModel
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedPhotoData: [Data]

    init(scrapbookYear: ScrapbookYear, entryToEdit: JournalEntry? = nil) {
        self.scrapbookYear = scrapbookYear
        self.entryToEdit = entryToEdit
        _viewModel = StateObject(wrappedValue: EntryEditorViewModel(entry: entryToEdit))
        _selectedPhotoData = State(initialValue: entryToEdit?.photos.map(\.imageData) ?? [])
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Page") {
                    TextField("Title", text: $viewModel.title)
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    Picker("Mood", selection: $viewModel.mood) {
                        ForEach(viewModel.moodOptions, id: \.self) { mood in
                            Text(mood).tag(mood)
                        }
                    }
                }

                Section("Memory") {
                    TextEditor(text: $viewModel.bodyText)
                        .frame(minHeight: 140)
                }

                Section("Tags") {
                    TextField("friends, spring, home", text: $viewModel.tagsText)
                        .textInputAutocapitalization(.never)
                }

                Section("Photos") {
                    PhotosPicker(
                        selection: $selectedPhotoItems,
                        maxSelectionCount: 6,
                        matching: .images
                    ) {
                        Label("Add Photos", systemImage: "photo.badge.plus")
                    }

                    if selectedPhotoData.isEmpty {
                        Text("Add up to six photos for this scrapbook page.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(Array(selectedPhotoData.enumerated()), id: \.offset) { _, data in
                                if let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 110)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                            }
                        }

                        Button("Remove selected photos", role: .destructive) {
                            selectedPhotoItems = []
                            selectedPhotoData = []
                        }
                    }
                }
            }
            .navigationTitle(entryToEdit == nil ? "New Page" : "Edit Page")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
            }
            .onChange(of: selectedPhotoItems) { _, newItems in
                Task {
                    selectedPhotoData = await loadPhotoData(from: newItems)
                }
            }
        }
    }

    private func save() {
        if let entryToEdit {
            viewModel.update(entryToEdit)
            replacePhotos(for: entryToEdit)
        } else {
            let entry = viewModel.makeEntry()
            entry.scrapbookYear = scrapbookYear
            attachPhotos(to: entry)
            scrapbookYear.entries.append(entry)
        }
    }

    private func attachPhotos(to entry: JournalEntry) {
        entry.photos = selectedPhotoData.map { data in
            let photo = JournalPhoto(imageData: data)
            photo.entry = entry
            return photo
        }
    }

    private func replacePhotos(for entry: JournalEntry) {
        entry.photos.removeAll()
        attachPhotos(to: entry)
    }

    private func loadPhotoData(from items: [PhotosPickerItem]) async -> [Data] {
        var loadedData: [Data] = []

        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                loadedData.append(data)
            }
        }

        return loadedData
    }
}

struct EntryEditorView_Previews: PreviewProvider {
    static var previews: some View {
        EntryEditorView(scrapbookYear: SampleData.previewYears[0])
    }
}
