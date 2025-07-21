import Foundation

public enum ThemeTime: String, Codable {
    case light
    case dark
}

public struct Theme: Codable {
    public let name: String
    public let time: ThemeTime
    public let colors: ColorTheme
    public let texts: TextTheme

    public init(name: String, time: ThemeTime, colors: ColorTheme, texts: TextTheme) {
        self.name = name
        self.time = time
        self.colors = colors
        self.texts = texts
    }
}

public extension Theme {
    static let light = Theme(name: "Light", time: .light, colors: .light, texts: .standard)
    static let dark = Theme(name: "Dark", time: .dark, colors: .dark, texts: .standard)
}
