//
//  YearbookTheme.swift
//  Final Project
//

import SwiftUI

enum YearbookTheme {
    static let colorSchemeKey = "yearbookColorScheme"
    static let colorSchemeNames = ["pink", "blue", "green", "red", "yellow", "purple", "orange"]

    private struct Palette {
        let ink: Color
        let paper: Color
        let paperShadow: Color
        let primary: Color
        let soft: Color
        let secondary: Color
        let tertiary: Color
        let bright: Color
    }

    private static var currentColorScheme: String {
        UserDefaults.standard.string(forKey: colorSchemeKey) ?? "blue"
    }

    static var ink: Color {
        currentPalette.ink
    }

    static var paper: Color {
        currentPalette.paper
    }

    static var paperShadow: Color {
        currentPalette.paperShadow
    }

    static var rose: Color {
        currentPalette.primary
    }

    static var blush: Color {
        currentPalette.soft
    }

    static var lavender: Color {
        currentPalette.secondary
    }

    static var sage: Color {
        currentPalette.tertiary
    }

    static var sky: Color {
        currentPalette.primary
    }

    static var butter: Color {
        currentPalette.bright
    }

    private static var currentPalette: Palette {
        palette(for: currentColorScheme)
    }

    static func color(for themeName: String) -> Color {
        switch themeName.lowercased() {
        case "pink", "rose":
            return palette(for: "pink").primary
        case "green", "sage":
            return palette(for: "green").primary
        case "red":
            return palette(for: "red").primary
        case "yellow", "butter":
            return palette(for: "yellow").primary
        case "purple", "lavender":
            return palette(for: "purple").primary
        case "orange":
            return palette(for: "orange").primary
        case "blue", "sky":
            return palette(for: "blue").primary
        default:
            return rose
        }
    }

    private static func palette(for name: String) -> Palette {
        switch name.lowercased() {
        case "pink":
            return Palette(
                ink: Color(red: 0.22, green: 0.14, blue: 0.18),
                paper: Color(red: 1.00, green: 0.96, blue: 0.98),
                paperShadow: Color(red: 0.65, green: 0.45, blue: 0.52),
                primary: Color(red: 0.86, green: 0.45, blue: 0.58),
                soft: Color(red: 0.98, green: 0.80, blue: 0.86),
                secondary: Color(red: 0.78, green: 0.56, blue: 0.72),
                tertiary: Color(red: 0.64, green: 0.70, blue: 0.58),
                bright: Color(red: 0.96, green: 0.72, blue: 0.80)
            )
        case "green":
            return Palette(
                ink: Color(red: 0.13, green: 0.21, blue: 0.17),
                paper: Color(red: 0.96, green: 0.99, blue: 0.96),
                paperShadow: Color(red: 0.38, green: 0.56, blue: 0.43),
                primary: Color(red: 0.34, green: 0.61, blue: 0.43),
                soft: Color(red: 0.78, green: 0.91, blue: 0.81),
                secondary: Color(red: 0.47, green: 0.70, blue: 0.59),
                tertiary: Color(red: 0.38, green: 0.64, blue: 0.66),
                bright: Color(red: 0.78, green: 0.88, blue: 0.56)
            )
        case "red":
            return Palette(
                ink: Color(red: 0.24, green: 0.13, blue: 0.12),
                paper: Color(red: 1.00, green: 0.96, blue: 0.95),
                paperShadow: Color(red: 0.62, green: 0.36, blue: 0.34),
                primary: Color(red: 0.78, green: 0.25, blue: 0.24),
                soft: Color(red: 0.97, green: 0.76, blue: 0.73),
                secondary: Color(red: 0.82, green: 0.43, blue: 0.39),
                tertiary: Color(red: 0.62, green: 0.59, blue: 0.42),
                bright: Color(red: 0.96, green: 0.62, blue: 0.52)
            )
        case "yellow":
            return Palette(
                ink: Color(red: 0.24, green: 0.19, blue: 0.10),
                paper: Color(red: 1.00, green: 0.99, blue: 0.94),
                paperShadow: Color(red: 0.66, green: 0.54, blue: 0.30),
                primary: Color(red: 0.83, green: 0.62, blue: 0.16),
                soft: Color(red: 0.99, green: 0.91, blue: 0.63),
                secondary: Color(red: 0.86, green: 0.70, blue: 0.30),
                tertiary: Color(red: 0.57, green: 0.66, blue: 0.42),
                bright: Color(red: 0.96, green: 0.78, blue: 0.28)
            )
        case "purple":
            return Palette(
                ink: Color(red: 0.18, green: 0.15, blue: 0.25),
                paper: Color(red: 0.98, green: 0.96, blue: 1.00),
                paperShadow: Color(red: 0.48, green: 0.40, blue: 0.63),
                primary: Color(red: 0.55, green: 0.43, blue: 0.78),
                soft: Color(red: 0.86, green: 0.80, blue: 0.96),
                secondary: Color(red: 0.66, green: 0.54, blue: 0.84),
                tertiary: Color(red: 0.52, green: 0.66, blue: 0.70),
                bright: Color(red: 0.75, green: 0.64, blue: 0.91)
            )
        case "orange":
            return Palette(
                ink: Color(red: 0.25, green: 0.16, blue: 0.10),
                paper: Color(red: 1.00, green: 0.97, blue: 0.94),
                paperShadow: Color(red: 0.67, green: 0.44, blue: 0.28),
                primary: Color(red: 0.86, green: 0.43, blue: 0.18),
                soft: Color(red: 0.98, green: 0.82, blue: 0.66),
                secondary: Color(red: 0.82, green: 0.55, blue: 0.30),
                tertiary: Color(red: 0.62, green: 0.68, blue: 0.44),
                bright: Color(red: 0.95, green: 0.63, blue: 0.32)
            )
        default:
            return Palette(
                ink: Color(red: 0.12, green: 0.17, blue: 0.24),
                paper: Color(red: 0.95, green: 0.98, blue: 1.00),
                paperShadow: Color(red: 0.33, green: 0.48, blue: 0.62),
                primary: Color(red: 0.24, green: 0.52, blue: 0.78),
                soft: Color(red: 0.78, green: 0.89, blue: 0.98),
                secondary: Color(red: 0.48, green: 0.63, blue: 0.86),
                tertiary: Color(red: 0.48, green: 0.70, blue: 0.72),
                bright: Color(red: 0.76, green: 0.87, blue: 0.98)
            )
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
