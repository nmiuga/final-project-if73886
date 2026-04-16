//
//  FavoriteDetailView.swift
//  Final Project
//

import SwiftUI

struct FavoriteDetailView: View {
    let favorite: FavoriteItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 14) {
                    Image(systemName: iconName)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .frame(width: 72, height: 72)
                        .background(YearbookTheme.butter)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(favorite.title)
                            .font(.largeTitle.bold())
                            .foregroundStyle(YearbookTheme.ink)

                        Text(favorite.category)
                            .font(.headline)
                            .foregroundStyle(YearbookTheme.rose)
                    }
                }
                .padding(18)
                .paperCard()

                if !favorite.note.isEmpty {
                    DetailBlock(title: "Why I Saved It", text: favorite.note, iconName: "text.quote")
                }

                DetailBlock(
                    title: "Added",
                    text: YearbookDate.displayDate.string(from: favorite.date),
                    iconName: "calendar"
                )
            }
            .padding()
        }
        .scrapbookBackground()
        .navigationTitle("Favorite")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var iconName: String {
        switch favorite.category.lowercased() {
        case "song", "music":
            return "music.note"
        case "drink":
            return "cup.and.saucer.fill"
        case "place":
            return "mappin.and.ellipse"
        case "style", "clothes":
            return "sparkles"
        default:
            return "heart.fill"
        }
    }
}

private struct DetailBlock: View {
    let title: String
    let text: String
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: iconName)
                .font(.headline)
                .foregroundStyle(YearbookTheme.ink)

            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .paperCard()
    }
}

struct FavoriteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FavoriteDetailView(favorite: SampleData.previewYears[0].favorites[0])
        }
    }
}
