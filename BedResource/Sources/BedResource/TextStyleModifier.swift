import SwiftUI

public extension FontWeight {
    var fontWeightValue: Font.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        }
    }
}

public struct TextStyleModifier: ViewModifier {
    public let style: TextStyle

    public func body(content: Content) -> some View {
        content
            .font(.custom(style.fontFamily, size: CGFloat(style.fontSize)).weight(style.fontWeight.fontWeightValue))
            .tracking(CGFloat(style.letterSpacing))
    }
}

public extension View {
    func textStyle(_ style: TextStyle) -> some View {
        modifier(TextStyleModifier(style: style))
    }
}

