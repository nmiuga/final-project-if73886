//
//  SectionTitle.swift
//  Final Project
//

import SwiftUI

struct SectionTitle: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(YearbookTheme.ink)

            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SectionTitle_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitle(title: "Monthly Recaps", subtitle: "A soft little summary")
            .padding()
    }
}
