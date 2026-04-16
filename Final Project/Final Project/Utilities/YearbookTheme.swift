//
//  YearbookTheme.swift
//  Final Project
//

import SwiftUI

enum YearbookTheme {
    static let ink = Color(red: 0.19, green: 0.16, blue: 0.17)
    static let paper = Color(red: 0.99, green: 0.96, blue: 0.94)
    static let paperShadow = Color(red: 0.65, green: 0.45, blue: 0.48)
    static let rose = Color(red: 0.86, green: 0.45, blue: 0.55)
    static let blush = Color(red: 0.98, green: 0.80, blue: 0.84)
    static let lavender = Color(red: 0.74, green: 0.63, blue: 0.83)
    static let sage = Color(red: 0.59, green: 0.70, blue: 0.58)
    static let sky = Color(red: 0.55, green: 0.72, blue: 0.86)
    static let butter = Color(red: 0.96, green: 0.78, blue: 0.38)

    static func color(for themeName: String) -> Color {
        switch themeName {
        case "lavender":
            return lavender
        case "sage":
            return sage
        case "sky":
            return sky
        case "butter":
            return butter
        default:
            return rose
        }
    }
}

extension View {
    func paperCard(cornerRadius: CGFloat = 8) -> some View {
        self
            .background(Color.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: YearbookTheme.paperShadow.opacity(0.14), radius: 14, x: 0, y: 8)
    }

    func scrapbookBackground() -> some View {
        self.background(YearbookTheme.paper.ignoresSafeArea())
    }
}
