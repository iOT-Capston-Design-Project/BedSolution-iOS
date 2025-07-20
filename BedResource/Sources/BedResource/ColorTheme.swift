import SwiftUI

private struct RGB: Codable {
    let r: Double
    let g: Double
    let b: Double
}

public struct ColorTheme: Codable {
    public let primary: Color
    public let onPrimary: Color
    public let secondary: Color
    public let onSecondary: Color
    public let tertiary: Color
    public let onTertiary: Color
    public let error: Color
    public let onError: Color
    public let primaryContainer: Color
    public let onPrimaryContainer: Color
    public let secondaryContainer: Color
    public let onSecondaryContainer: Color
    public let tertiaryContainer: Color
    public let onTertiaryContainer: Color
    public let errorContainer: Color
    public let onErrorContainer: Color
    public let surfaceDim: Color
    public let surface: Color
    public let surfaceBright: Color
    public let onSurface: Color
    public let onSurfaceVariant: Color
    public let outline: Color
    public let outlineVariant: Color
    public let surfaceContainerLowest: Color
    public let surfaceContainerLow: Color
    public let surfaceContainer: Color
    public let surfaceContainerHigh: Color
    public let surfaceContainerHighest: Color

    public init(
        primary: Color,
        onPrimary: Color,
        secondary: Color,
        onSecondary: Color,
        tertiary: Color,
        onTertiary: Color,
        error: Color,
        onError: Color,
        primaryContainer: Color,
        onPrimaryContainer: Color,
        secondaryContainer: Color,
        onSecondaryContainer: Color,
        tertiaryContainer: Color,
        onTertiaryContainer: Color,
        errorContainer: Color,
        onErrorContainer: Color,
        surfaceDim: Color,
        surface: Color,
        surfaceBright: Color,
        onSurface: Color,
        onSurfaceVariant: Color,
        outline: Color,
        outlineVariant: Color,
        surfaceContainerLowest: Color,
        surfaceContainerLow: Color,
        surfaceContainer: Color,
        surfaceContainerHigh: Color,
        surfaceContainerHighest: Color
    ) {
        self.primary = primary
        self.onPrimary = onPrimary
        self.secondary = secondary
        self.onSecondary = onSecondary
        self.tertiary = tertiary
        self.onTertiary = onTertiary
        self.error = error
        self.onError = onError
        self.primaryContainer = primaryContainer
        self.onPrimaryContainer = onPrimaryContainer
        self.secondaryContainer = secondaryContainer
        self.onSecondaryContainer = onSecondaryContainer
        self.tertiaryContainer = tertiaryContainer
        self.onTertiaryContainer = onTertiaryContainer
        self.errorContainer = errorContainer
        self.onErrorContainer = onErrorContainer
        self.surfaceDim = surfaceDim
        self.surface = surface
        self.surfaceBright = surfaceBright
        self.onSurface = onSurface
        self.onSurfaceVariant = onSurfaceVariant
        self.outline = outline
        self.outlineVariant = outlineVariant
        self.surfaceContainerLowest = surfaceContainerLowest
        self.surfaceContainerLow = surfaceContainerLow
        self.surfaceContainer = surfaceContainer
        self.surfaceContainerHigh = surfaceContainerHigh
        self.surfaceContainerHighest = surfaceContainerHighest
    }
    public enum CodingKeys: String, CodingKey {
        case primary
        case onPrimary
        case secondary
        case onSecondary
        case tertiary
        case onTertiary
        case error
        case onError
        case primaryContainer
        case onPrimaryContainer
        case secondaryContainer
        case onSecondaryContainer
        case tertiaryContainer
        case onTertiaryContainer
        case errorContainer
        case onErrorContainer
        case surfaceDim
        case surface
        case surfaceBright
        case onSurface
        case onSurfaceVariant
        case outline
        case outlineVariant
        case surfaceContainerLowest
        case surfaceContainerLow
        case surfaceContainer
        case surfaceContainerHigh
        case surfaceContainerHighest
    }

    private static func decodeColor(_ container: KeyedDecodingContainer<CodingKeys>, key: CodingKeys) throws -> Color {
        let rgb = try container.decode(RGB.self, forKey: key)
        return Color(red: rgb.r, green: rgb.g, blue: rgb.b)
    }

    private static func encodeColor(_ color: Color, to container: inout KeyedEncodingContainer<CodingKeys>, key: CodingKeys) throws {
        #if canImport(UIKit)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb = RGB(r: Double(r), g: Double(g), b: Double(b))
        #else
        let rgb = RGB(r: 0, g: 0, b: 0)
        #endif
        try container.encode(rgb, forKey: key)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.primary = try Self.decodeColor(container, key: .primary)
        self.onPrimary = try Self.decodeColor(container, key: .onPrimary)
        self.secondary = try Self.decodeColor(container, key: .secondary)
        self.onSecondary = try Self.decodeColor(container, key: .onSecondary)
        self.tertiary = try Self.decodeColor(container, key: .tertiary)
        self.onTertiary = try Self.decodeColor(container, key: .onTertiary)
        self.error = try Self.decodeColor(container, key: .error)
        self.onError = try Self.decodeColor(container, key: .onError)
        self.primaryContainer = try Self.decodeColor(container, key: .primaryContainer)
        self.onPrimaryContainer = try Self.decodeColor(container, key: .onPrimaryContainer)
        self.secondaryContainer = try Self.decodeColor(container, key: .secondaryContainer)
        self.onSecondaryContainer = try Self.decodeColor(container, key: .onSecondaryContainer)
        self.tertiaryContainer = try Self.decodeColor(container, key: .tertiaryContainer)
        self.onTertiaryContainer = try Self.decodeColor(container, key: .onTertiaryContainer)
        self.errorContainer = try Self.decodeColor(container, key: .errorContainer)
        self.onErrorContainer = try Self.decodeColor(container, key: .onErrorContainer)
        self.surfaceDim = try Self.decodeColor(container, key: .surfaceDim)
        self.surface = try Self.decodeColor(container, key: .surface)
        self.surfaceBright = try Self.decodeColor(container, key: .surfaceBright)
        self.onSurface = try Self.decodeColor(container, key: .onSurface)
        self.onSurfaceVariant = try Self.decodeColor(container, key: .onSurfaceVariant)
        self.outline = try Self.decodeColor(container, key: .outline)
        self.outlineVariant = try Self.decodeColor(container, key: .outlineVariant)
        self.surfaceContainerLowest = try Self.decodeColor(container, key: .surfaceContainerLowest)
        self.surfaceContainerLow = try Self.decodeColor(container, key: .surfaceContainerLow)
        self.surfaceContainer = try Self.decodeColor(container, key: .surfaceContainer)
        self.surfaceContainerHigh = try Self.decodeColor(container, key: .surfaceContainerHigh)
        self.surfaceContainerHighest = try Self.decodeColor(container, key: .surfaceContainerHighest)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try Self.encodeColor(primary, to: &container, key: .primary)
        try Self.encodeColor(onPrimary, to: &container, key: .onPrimary)
        try Self.encodeColor(secondary, to: &container, key: .secondary)
        try Self.encodeColor(onSecondary, to: &container, key: .onSecondary)
        try Self.encodeColor(tertiary, to: &container, key: .tertiary)
        try Self.encodeColor(onTertiary, to: &container, key: .onTertiary)
        try Self.encodeColor(error, to: &container, key: .error)
        try Self.encodeColor(onError, to: &container, key: .onError)
        try Self.encodeColor(primaryContainer, to: &container, key: .primaryContainer)
        try Self.encodeColor(onPrimaryContainer, to: &container, key: .onPrimaryContainer)
        try Self.encodeColor(secondaryContainer, to: &container, key: .secondaryContainer)
        try Self.encodeColor(onSecondaryContainer, to: &container, key: .onSecondaryContainer)
        try Self.encodeColor(tertiaryContainer, to: &container, key: .tertiaryContainer)
        try Self.encodeColor(onTertiaryContainer, to: &container, key: .onTertiaryContainer)
        try Self.encodeColor(errorContainer, to: &container, key: .errorContainer)
        try Self.encodeColor(onErrorContainer, to: &container, key: .onErrorContainer)
        try Self.encodeColor(surfaceDim, to: &container, key: .surfaceDim)
        try Self.encodeColor(surface, to: &container, key: .surface)
        try Self.encodeColor(surfaceBright, to: &container, key: .surfaceBright)
        try Self.encodeColor(onSurface, to: &container, key: .onSurface)
        try Self.encodeColor(onSurfaceVariant, to: &container, key: .onSurfaceVariant)
        try Self.encodeColor(outline, to: &container, key: .outline)
        try Self.encodeColor(outlineVariant, to: &container, key: .outlineVariant)
        try Self.encodeColor(surfaceContainerLowest, to: &container, key: .surfaceContainerLowest)
        try Self.encodeColor(surfaceContainerLow, to: &container, key: .surfaceContainerLow)
        try Self.encodeColor(surfaceContainer, to: &container, key: .surfaceContainer)
        try Self.encodeColor(surfaceContainerHigh, to: &container, key: .surfaceContainerHigh)
        try Self.encodeColor(surfaceContainerHighest, to: &container, key: .surfaceContainerHighest)
    }
}

private extension Color {
    init(rgb: (Double, Double, Double)) {
        self.init(red: rgb.0, green: rgb.1, blue: rgb.2)
    }
}

public extension ColorTheme {
    static let light = ColorTheme(
        primary: Color(rgb: (0.2392, 0.4549, 0.7137)),
        onPrimary: Color(rgb: (1.0, 1.0, 1.0)),
        secondary: Color(rgb: (0.1765, 0.6667, 0.6196)),
        onSecondary: Color(rgb: (1.0, 1.0, 1.0)),
        tertiary: Color(rgb: (0.2471, 0.4902, 0.3451)),
        onTertiary: Color(rgb: (1.0, 1.0, 1.0)),
        error: Color(rgb: (0.8824, 0.2667, 0.2039)),
        onError: Color(rgb: (1.0, 1.0, 1.0)),
        primaryContainer: Color(rgb: (0.7440, 0.8805, 1.0)),
        onPrimaryContainer: Color(rgb: (0.0471, 0.1569, 0.3647)),
        secondaryContainer: Color(rgb: (0.5961, 0.8235, 0.7529)),
        onSecondaryContainer: Color(rgb: (0.1572, 0.1572, 0.1572)),
        tertiaryContainer: Color(rgb: (0.9059, 0.9373, 0.7804)),
        onTertiaryContainer: Color(rgb: (0.2314, 0.2314, 0.1020)),
        errorContainer: Color(rgb: (1.0, 0.9020, 0.8824)),
        onErrorContainer: Color(rgb: (0.6980, 0.1333, 0.1333)),
        surfaceDim: Color(rgb: (0.9056, 0.9056, 0.9056)),
        surface: Color(rgb: (0.9315, 0.9315, 0.9315)),
        surfaceBright: Color(rgb: (0.9843, 0.9843, 0.9843)),
        onSurface: Color(rgb: (0.1572, 0.1572, 0.1572)),
        onSurfaceVariant: Color(rgb: (0.3606, 0.3606, 0.3606)),
        outline: Color(rgb: (0.8574, 0.8574, 0.8574)),
        outlineVariant: Color(rgb: (0.9393, 0.9393, 0.9393)),
        surfaceContainerLowest: Color(rgb: (1.0, 1.0, 1.0)),
        surfaceContainerLow: Color(rgb: (0.9843, 0.9843, 0.9843)),
        surfaceContainer: Color(rgb: (0.9866, 0.9866, 0.9866)),
        surfaceContainerHigh: Color(rgb: (0.9059, 0.9176, 0.9216)),
        surfaceContainerHighest: Color(rgb: (0.8627, 0.8784, 0.8824))
    )

    static let dark = ColorTheme(
        primary: Color(rgb: (0.3424, 0.6037, 0.9172)),
        onPrimary: Color(rgb: (1.0, 1.0, 1.0)),
        secondary: Color(rgb: (0.2721, 0.7625, 0.7155)),
        onSecondary: Color(rgb: (1.0, 1.0, 1.0)),
        tertiary: Color(rgb: (0.3592, 0.6431, 0.4737)),
        onTertiary: Color(rgb: (1.0, 1.0, 1.0)),
        error: Color(rgb: (0.9375, 0.4221, 0.3696)),
        onError: Color(rgb: (1.0, 1.0, 1.0)),
        primaryContainer: Color(rgb: (0.5571, 0.7933, 1.0)),
        onPrimaryContainer: Color(rgb: (0.0471, 0.1569, 0.3647)),
        secondaryContainer: Color(rgb: (0.5961, 0.8235, 0.7529)),
        onSecondaryContainer: Color(rgb: (0.1572, 0.1572, 0.1572)),
        tertiaryContainer: Color(rgb: (0.9059, 0.9373, 0.7804)),
        onTertiaryContainer: Color(rgb: (0.2314, 0.2314, 0.1020)),
        errorContainer: Color(rgb: (1.0, 0.9020, 0.8824)),
        onErrorContainer: Color(rgb: (0.6980, 0.1333, 0.1333)),
        surfaceDim: Color(rgb: (0.1038, 0.1038, 0.1038)),
        surface: Color(rgb: (0.1572, 0.1572, 0.1572)),
        surfaceBright: Color(rgb: (0.2506, 0.2506, 0.2506)),
        onSurface: Color(rgb: (0.9501, 0.9501, 0.9501)),
        onSurfaceVariant: Color(rgb: (0.6974, 0.6974, 0.6974)),
        outline: Color(rgb: (0.1672, 0.1672, 0.1672)),
        outlineVariant: Color(rgb: (0.2063, 0.2063, 0.2063)),
        surfaceContainerLowest: Color(rgb: (0.1406, 0.1406, 0.1406)),
        surfaceContainerLow: Color(rgb: (0.1727, 0.1727, 0.1727)),
        surfaceContainer: Color(rgb: (0.2880, 0.2880, 0.2880)),
        surfaceContainerHigh: Color(rgb: (0.3636, 0.3636, 0.3636)),
        surfaceContainerHighest: Color(rgb: (0.4954, 0.4954, 0.4954))
    )
}
