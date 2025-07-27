//
//  HexToColor.swift
//  BedSolution
//
//  Created by 이재호 on 7/26/25.
//

import Foundation
import SwiftUI

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)

        if hex.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let r, g, b, a: Double

        switch hex.count {
        case 7: // #RRGGBB
            r = Double((color & 0xFF0000) >> 16) / 255.0
            g = Double((color & 0x00FF00) >> 8) / 255.0
            b = Double(color & 0x0000FF) / 255.0
            a = 1.0
        case 9: // #RRGGBBAA
            r = Double((color & 0xFF000000) >> 24) / 255.0
            g = Double((color & 0x00FF0000) >> 16) / 255.0
            b = Double((color & 0x0000FF00) >> 8) / 255.0
            a = Double(color & 0x000000FF) / 255.0
        case 6: // RRGGBB
            r = Double((color & 0xFF0000) >> 16) / 255.0
            g = Double((color & 0x00FF00) >> 8) / 255.0
            b = Double(color & 0x0000FF) / 255.0
            a = 1.0
        case 8: // RRGGBBAA
            r = Double((color & 0xFF000000) >> 24) / 255.0
            g = Double((color & 0x00FF0000) >> 16) / 255.0
            b = Double((color & 0x0000FF00) >> 8) / 255.0
            a = Double(color & 0x000000FF) / 255.0
        default:
            r = 1.0
            g = 1.0
            b = 1.0
            a = 1.0
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
