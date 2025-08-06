//
//  ColorSet.swift
//  BedSolution
//
//  Created by 이재호 on 7/26/25.
//

import Foundation
import SwiftUI

public struct ColorSet: Codable {
    let light: String
    let dark: String
    
    init(light: String, dark: String) {
        self.light = light
        self.dark = dark
    }
    
    init(hex: String) {
        self.init(light: hex, dark: hex)
    }
}

private struct ForegroundColorSetModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var colorSet: ColorSet
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(colorScheme == .dark ? Color(hex: colorSet.dark) : Color(hex: colorSet.light))
    }
}

private struct BackgroundColorShapeModifier<S: InsettableShape>: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var colorSet: ColorSet
    var shape: S
    
    init(colorSet: ColorSet, in shape: S) {
        self.colorSet = colorSet
        self.shape = shape
    }
    
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .dark ? Color(hex: colorSet.dark) : Color(hex: colorSet.light), in: shape)
    }
}

private struct BackgroundColorSetModifier: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme
    var colorSet: ColorSet
    var ignoresSafeAreaEdges: Edge.Set
    
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .dark ? Color(hex: colorSet.dark) : Color(hex: colorSet.light), ignoresSafeAreaEdges: ignoresSafeAreaEdges)
    }
}


extension View {
    public func foregroundColorSet(_ colorSet: ColorSet) -> some View {
        modifier(ForegroundColorSetModifier(colorSet: colorSet))
    }
    
    public func backgroundColorSet(_ colorSet: ColorSet, in shape: some InsettableShape) -> some View {
        modifier(BackgroundColorShapeModifier(colorSet: colorSet, in: shape))
    }
    
    public func backgroundColorSet(_ colorSet: ColorSet, ignoresSafeAreaEdges: Edge.Set = .all) -> some View {
        modifier(BackgroundColorSetModifier(colorSet: colorSet, ignoresSafeAreaEdges: ignoresSafeAreaEdges))
    }
}
