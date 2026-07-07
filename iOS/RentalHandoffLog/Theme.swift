import SwiftUI

enum Theme {
    static let background = Color(hex: "#071A18")
    static let card = Color(hex: "#0E2A26")
    static let accent = Color(hex: "#00897B")
    static let accentDeep = Color(hex: "#004D40")
    static let textPrimary = Color(hex: "#E6F7F4")
    static let textSecondary = Color(hex: "#E6F7F4").opacity(0.6)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)
}

extension Color {
    init(hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        let r = Double((v >> 16) & 0xFF) / 255.0
        let g = Double((v >> 8) & 0xFF) / 255.0
        let b = Double(v & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
