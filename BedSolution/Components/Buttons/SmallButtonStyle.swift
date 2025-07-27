//
//  SmallButtonStyle.swift
//  BedSolution
//
//  Created by 이재호 on 7/27/25.
//

import Foundation
import SwiftUI

struct SmallButtonStyle: ButtonStyle {
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
            .frame(minHeight: 35)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .backgroundColorSet(
                backgroundColorSet(config: configuration),
                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(lineWidth: 2)
                    .foregroundColorSet(outlineColorSet())
                    .opacity(option == .fiilled ? 0: 1)
            }
            .scaleEffect(CGSize(width: configuration.isPressed ? 0.98: 1, height: configuration.isPressed ? 0.98: 1))
            .animation(.interactiveSpring, value: configuration.isPressed)
    }
}


#Preview {
    Button(action: {}) {
        Text("Test")
    }
    .buttonStyle(SmallButtonStyle(
        option: .outline,
        primaryColor: ColorTheme._default.secondary,
        onPrimaryColor: ColorTheme._default.onSecondary
    ))
    .disabled(true)
}
