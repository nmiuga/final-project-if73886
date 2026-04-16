//
//  TagChip.swift
//  Final Project
//

import SwiftUI

struct TagChip: View {
    let text: String
    var color: Color = YearbookTheme.rose

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(color.opacity(0.13))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct TagChip_Previews: PreviewProvider {
    static var previews: some View {
        TagChip(text: "spring")
            .padding()
    }
}
