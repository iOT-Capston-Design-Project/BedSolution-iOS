//
//  ColorTheme.swift
//  BedSolution
//
//  Created by 이재호 on 7/26/25.
//

import Foundation

public struct ColorTheme {
    let primary: ColorSet
    let onPrimary: ColorSet
    let secondary: ColorSet
    let onSecondary: ColorSet
    let tertiary: ColorSet
    let onTertiary: ColorSet
    let error: ColorSet
    let onError: ColorSet
    let primaryContainer: ColorSet
    let onPrimaryContainer: ColorSet
    let secondaryContainer: ColorSet
    let onSecondaryContainer: ColorSet
    let tertiaryContainer: ColorSet
    let onTertiaryContainer: ColorSet
    let errorContainer: ColorSet
    let onErrorContainer: ColorSet
    let surfaceDim: ColorSet
    let surface: ColorSet
    let surfaceBright: ColorSet
    let surfaceContainerLowest: ColorSet
    let surfaceContainerLow: ColorSet
    let surfaceContainer: ColorSet
    let surfaceContainerHigh: ColorSet
    let surfaceContainerHighest: ColorSet
    let onSurface: ColorSet
    let onSurfaceVarient: ColorSet
    let outline: ColorSet
    let outlineVariant: ColorSet
}

public extension ColorTheme {
    static let _default = ColorTheme(
        primary: ColorSet(light: "3D74B6", dark: "579AEA"),
        onPrimary: ColorSet(light: "FFFFFF", dark: "FFFFFF"),
        secondary: ColorSet(light: "2DAA9E", dark: "45C2B6"),
        onSecondary: ColorSet(light: "FFFFFF", dark: "FFFFFF"),
        tertiary: ColorSet(light: "3F7D58", dark: "5CA479"),
        onTertiary: ColorSet(light: "FFFFFF", dark: "FFFFFF"),
        error: ColorSet(light: "E14434", dark: "EF6C5E"),
        onError: ColorSet(light: "FFFFFF", dark: "FFFFFF"),
        primaryContainer: ColorSet(light: "BEE1FF", dark: "8ECAFF"),
        onPrimaryContainer: ColorSet(light: "0C285D", dark: "0C285D"),
        secondaryContainer: ColorSet(light: "98D2C0", dark: "98D2C0"),
        onSecondaryContainer: ColorSet(light: "282828", dark: "282828"),
        tertiaryContainer: ColorSet(light: "E7EFC7", dark: "E7EFC7"),
        onTertiaryContainer: ColorSet(light: "3B3B1A", dark: "3B3B1A"),
        errorContainer: ColorSet(light: "FFE6E1", dark: "FFE6E1"),
        onErrorContainer: ColorSet(light: "B22222", dark: "B22222"),
        surfaceDim: ColorSet(light: "E7E7E7", dark: "1A1A1A"),
        surface: ColorSet(light: "EEEEEE", dark: "282828"),
        surfaceBright: ColorSet(light: "FBF8FB", dark: "404040"),
        surfaceContainerLowest: ColorSet(light: "FFFFFF", dark: "242424"),
        surfaceContainerLow: ColorSet(light: "FBF8FB", dark: "2C2C2C"),
        surfaceContainer: ColorSet(light: "FCFCFC", dark: "494949"),
        surfaceContainerHigh: ColorSet(light: "E7EAEB", dark: "5D5D5D"),
        surfaceContainerHighest: ColorSet(light: "DCE0E1", dark: "7E7E7E"),
        onSurface: ColorSet(light: "282828", dark: "F2F2F2"),
        onSurfaceVarient: ColorSet(light: "5C5C5C", dark: "B2B2B2"),
        outline: ColorSet(light: "D6D0D8", dark: "282828"),
        outlineVariant: ColorSet(light: "F0F0F0", dark: "353535")
    )
}
