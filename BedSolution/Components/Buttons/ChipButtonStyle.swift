//
//  ChipButtonStyle.swift
//  BedSolution
//
//  Created by 이재호 on 7/27/25.
//

import Foundation
import SwiftUI

struct ChipButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    @Environment(\.isEnabled) private var isEnabled
    var option: ButtonStyleOption
    var primaryColor: ColorSet
    var onPrimaryColor: ColorSet
    
    private func backgroundColorSet(config: Configuration) -> ColorSet {
        if config.isPressed {
            return theme.colorTheme.surfaceDim
        } else if isEnabled && option == .fiilled {
            return primaryColor
        } else if isEnabled && option == .outline {
            return theme.colorTheme.surface
        } else {
            return theme.colorTheme.surfaceDim
        }
    }
    
    private func foregroundColorSet() -> ColorSet {
        if !isEnabled {
            return theme.colorTheme.onSurfaceVarient
        }
        return switch option {
        case .fiilled:
            onPrimaryColor
        case .outline:
            primaryColor
        }
    }
    
    private func outlineColorSet() -> ColorSet {
        if isEnabled {
            return primaryColor
        } else {
            return theme.colorTheme.outline
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColorSet(foregroundColorSet())
            .padding(EdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8))
            .frame(minWidth: 85, alignment: .leading)
            .frame(height: 35)
            .backgroundColorSet(
                backgroundColorSet(config: configuration),
                in: Capsule()
            )
            .overlay {
                Capsule()
                    .stroke(lineWidth: 2)
                    .foregroundColorSet(outlineColorSet())
                    .opacity(option == .fiilled ? 0: 1)
            }
            .scaleEffect(CGSize(width: configuration.isPressed ? 0.96: 1, height: 1))
            .animation(.interactiveSpring, value: configuration.isPressed)
    }
}


#Preview {
    Button(action: {}) {
        Text("Test")
    }
    .buttonStyle(ChipButtonStyle(
        option: .fiilled,
        primaryColor: ColorTheme._default.tertiary,
        onPrimaryColor: ColorTheme._default.onTertiary
    ))
}
