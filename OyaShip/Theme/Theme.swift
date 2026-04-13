import SwiftUI

// MARK: - Colors
enum C {
    static let brand      = Color(hex: "#FF6B35")
    static let brandMuted = Color(hex: "#2D1609")
    static let bg         = Color(hex: "#000000")
    static let card       = Color(hex: "#111111")
    static let cardHi     = Color(hex: "#1A1A1A")
    static let border     = Color(hex: "#222222")
    static let t1         = Color.white
    static let t2         = Color(hex: "#8E8E93")
    static let t3         = Color(hex: "#48484A")
    static let green      = Color(hex: "#30D158")
    static let red        = Color(hex: "#FF453A")
    static let blue       = Color(hex: "#0A84FF")
    static let yellow     = Color(hex: "#FFD60A")
}

// MARK: - Spacing (8pt grid)
enum S {
    static let _4: CGFloat = 4
    static let _8: CGFloat = 8
    static let _12: CGFloat = 12
    static let _16: CGFloat = 16
    static let _20: CGFloat = 20
    static let _24: CGFloat = 24
    static let _32: CGFloat = 32
    static let pad: CGFloat = 20
}

// MARK: - Radius
enum R {
    static let sm: CGFloat = 10
    static let md: CGFloat = 14
    static let lg: CGFloat = 18
    static let xl: CGFloat = 24
    static let full: CGFloat = 999
}

// MARK: - Typography
extension Font {
    static let d1  = Font.system(size: 34, weight: .bold, design: .rounded)
    static let h1  = Font.system(size: 22, weight: .bold, design: .rounded)
    static let h2  = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let b1  = Font.system(size: 16, weight: .regular)
    static let b2  = Font.system(size: 15, weight: .regular)
    static let cap = Font.system(size: 12, weight: .medium)
    static func num(_ s: CGFloat) -> Font { .system(size: s, weight: .bold, design: .rounded) }
}

// MARK: - Color hex init
extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: .init(charactersIn: "#"))
        var rgb: UInt64 = 0; Scanner(string: h).scanHexInt64(&rgb)
        self.init(red: Double((rgb >> 16) & 0xFF) / 255, green: Double((rgb >> 8) & 0xFF) / 255, blue: Double(rgb & 0xFF) / 255)
    }
}

// MARK: - Haptics
enum Tap {
    static func light() { UIImpactFeedbackGenerator(style: .light).impactOccurred() }
    static func med()   { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
}
