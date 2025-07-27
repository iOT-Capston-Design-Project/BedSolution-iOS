//
//  TextTheme.swift
//  BedSolution
//
//  Created by 이재호 on 7/27/25.
//

import Foundation

public struct TextTheme: Codable {
    let displayLarge: TextStyle
    let displayMedium: TextStyle
    let displaySmall: TextStyle
    let headlineLarge: TextStyle
    let headlineMedium: TextStyle
    let headlineSmall: TextStyle
    let titleLarge: TextStyle
    let titleMedium: TextStyle
    let titleSmall: TextStyle
    let bodyLarge: TextStyle
    let bodyMedium: TextStyle
    let bodySmall: TextStyle
    let labelLarge: TextStyle
    let labelMedium: TextStyle
    let labelSmall: TextStyle
    let emphasizedDisplayLarge: TextStyle
    let emphasizedDisplayMedium: TextStyle
    let emphasizedDisplaySmall: TextStyle
    let emphasizedHeadlineLarge: TextStyle
    let emphasizedHeadlineMedium: TextStyle
    let emphasizedHeadlineSmall: TextStyle
    let emphasizedTitleLarge: TextStyle
    let emphasizedTitleMedium: TextStyle
    let emphasizedTitleSmall: TextStyle
    let emphasizedBodyLarge: TextStyle
    let emphasizedBodyMedium: TextStyle
    let emphasizedBodySmall: TextStyle
    let emphasizedLabelLarge: TextStyle
    let emphasizedLabelMedium: TextStyle
    let emphasizedLabelSmall: TextStyle
    
    public init(
        displayLarge: TextStyle,
        displayMedium: TextStyle,
        displaySmall: TextStyle,
        headlineLarge: TextStyle,
        headlineMedium: TextStyle,
        headlineSmall: TextStyle,
        titleLarge: TextStyle,
        titleMedium: TextStyle,
        titleSmall: TextStyle,
        bodyLarge: TextStyle,
        bodyMedium: TextStyle,
        bodySmall: TextStyle,
        labelLarge: TextStyle,
        labelMedium: TextStyle,
        labelSmall: TextStyle,
        emphasizedDisplayLarge: TextStyle,
        emphasizedDisplayMedium: TextStyle,
        emphasizedDisplaySmall: TextStyle,
        emphasizedHeadlineLarge: TextStyle,
        emphasizedHeadlineMedium: TextStyle,
        emphasizedHeadlineSmall: TextStyle,
        emphasizedTitleLarge: TextStyle,
        emphasizedTitleMedium: TextStyle,
        emphasizedTitleSmall: TextStyle,
        emphasizedBodyLarge: TextStyle,
        emphasizedBodyMedium: TextStyle,
        emphasizedBodySmall: TextStyle,
        emphasizedLabelLarge: TextStyle,
        emphasizedLabelMedium: TextStyle,
        emphasizedLabelSmall: TextStyle
    ) {
        self.displayLarge = displayLarge
        self.displayMedium = displayMedium
        self.displaySmall = displaySmall
        self.headlineLarge = headlineLarge
        self.headlineMedium = headlineMedium
        self.headlineSmall = headlineSmall
        self.titleLarge = titleLarge
        self.titleMedium = titleMedium
        self.titleSmall = titleSmall
        self.bodyLarge = bodyLarge
        self.bodyMedium = bodyMedium
        self.bodySmall = bodySmall
        self.labelLarge = labelLarge
        self.labelMedium = labelMedium
        self.labelSmall = labelSmall
        self.emphasizedDisplayLarge = emphasizedDisplayLarge
        self.emphasizedDisplayMedium = emphasizedDisplayMedium
        self.emphasizedDisplaySmall = emphasizedDisplaySmall
        self.emphasizedHeadlineLarge = emphasizedHeadlineLarge
        self.emphasizedHeadlineMedium = emphasizedHeadlineMedium
        self.emphasizedHeadlineSmall = emphasizedHeadlineSmall
        self.emphasizedTitleLarge = emphasizedTitleLarge
        self.emphasizedTitleMedium = emphasizedTitleMedium
        self.emphasizedTitleSmall = emphasizedTitleSmall
        self.emphasizedBodyLarge = emphasizedBodyLarge
        self.emphasizedBodyMedium = emphasizedBodyMedium
        self.emphasizedBodySmall = emphasizedBodySmall
        self.emphasizedLabelLarge = emphasizedLabelLarge
        self.emphasizedLabelMedium = emphasizedLabelMedium
        self.emphasizedLabelSmall = emphasizedLabelSmall
    }
}

public extension TextTheme {
    static let _default = TextTheme(
        displayLarge: TextStyle(name: "Display Large", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 57, letterSpacing: 0),
        displayMedium: TextStyle(name: "Display Medium", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 45, letterSpacing: 0),
        displaySmall: TextStyle(name: "Display Small", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 36, letterSpacing: 0),
        headlineLarge: TextStyle(name: "Headline Large", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 32, letterSpacing: 0),
        headlineMedium: TextStyle(name: "Headline Medium", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 28, letterSpacing: 0),
        headlineSmall: TextStyle(name: "Headline Small", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 24, letterSpacing: 0),
        titleLarge: TextStyle(name: "Title Large", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 22, letterSpacing: 0),
        titleMedium: TextStyle(name: "Title Medium", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 16, letterSpacing: 0),
        titleSmall: TextStyle(name: "Title Small", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 14, letterSpacing: 0),
        bodyLarge: TextStyle(name: "Body Large", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 16, letterSpacing: 0),
        bodyMedium: TextStyle(name: "Body Medium", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 14, letterSpacing: 0),
        bodySmall: TextStyle(name: "Body Small", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 12, letterSpacing: 0),
        labelLarge: TextStyle(name: "Label Large", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 14, letterSpacing: 0),
        labelMedium: TextStyle(name: "Label Medium", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 12, letterSpacing: 0),
        labelSmall: TextStyle(name: "Label Small", fontFamily: "Pretendard Variable", fontWeight: .regular, fontSize: 11, letterSpacing: 0),
        emphasizedDisplayLarge: TextStyle(name: "Emphasized Display Large", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 57, letterSpacing: 0),
        emphasizedDisplayMedium: TextStyle(name: "Emphasized Display Medium", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 45, letterSpacing: 0),
        emphasizedDisplaySmall: TextStyle(name: "Emphasized Display Small", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 36, letterSpacing: 0),
        emphasizedHeadlineLarge: TextStyle(name: "Emphasized Headline Large", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 32, letterSpacing: 0),
        emphasizedHeadlineMedium: TextStyle(name: "Emphasized Headline Medium", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 28, letterSpacing: 0),
        emphasizedHeadlineSmall: TextStyle(name: "Emphasized Headline Small", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 24, letterSpacing: 0),
        emphasizedTitleLarge: TextStyle(name: "Emphasized Title Large", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 22, letterSpacing: 0),
        emphasizedTitleMedium: TextStyle(name: "Emphasized Title Medium", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 16, letterSpacing: 0),
        emphasizedTitleSmall: TextStyle(name: "Emphasized Title Small", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 14, letterSpacing: 0),
        emphasizedBodyLarge: TextStyle(name: "Emphasized Body Large", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 16, letterSpacing: 0),
        emphasizedBodyMedium: TextStyle(name: "Emphasized Body Medium", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 14, letterSpacing: 0),
        emphasizedBodySmall: TextStyle(name: "Emphasized Body Small", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 12, letterSpacing: 0),
        emphasizedLabelLarge: TextStyle(name: "Emphasized Label Large", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 14, letterSpacing: 0),
        emphasizedLabelMedium: TextStyle(name: "Emphasized Label Medium", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 12, letterSpacing: 0),
        emphasizedLabelSmall: TextStyle(name: "Emphasized Label Small", fontFamily: "Pretendard Variable", fontWeight: .semibold, fontSize: 11, letterSpacing: 0)
    )
}

