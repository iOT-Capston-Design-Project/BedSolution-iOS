//
//  TextSet.swift
//  BedSolution
//
//  Created by 이재호 on 7/26/25.
//

import Foundation
import SwiftUI

public enum FontWeight: String, Codable {
    case regular
    case medium
    case semibold
    case bold
    
    var weight: Font.Weight {
        switch self {
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
        }
    }
}

public struct TextStyle: Codable {
    let name: String
    let fontFamily: String
    let fontWeight: FontWeight
    let fontSize: Double
    let letterSpacing: Double

    init(name: String, fontFamily: String, fontWeight: FontWeight, fontSize: Double, letterSpacing: Double) {
        self.name = name
        self.fontFamily = fontFamily
        self.fontWeight = fontWeight
        self.fontSize = fontSize
        self.letterSpacing = letterSpacing
    }
}

private struct TextStyleModifier: ViewModifier {
    let style: TextStyle
    
    func body(content: Content) -> some View {
        content
            .font(.custom(style.fontFamily, size: style.fontSize).weight(style.fontWeight.weight))
    }
}

public extension View {
    func textStyle(_ style: TextStyle) -> some View {
        modifier(TextStyleModifier(style: style))
    }
}
