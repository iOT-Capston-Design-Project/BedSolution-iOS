//
//  ButtonStyles.swift
//  BedSolution
//
//  Created by 이재호 on 7/27/25.
//

import Foundation
import SwiftUI

public enum ButtonTypes {
    case chip
    case emphasized
    case small
}

extension View {
    @ViewBuilder
    public func buttonStyle(type: ButtonTypes, option: ButtonStyleOption, primary: ColorSet, onPrimary: ColorSet) -> some View {
        switch type {
        case .chip:
            self.buttonStyle(ChipButtonStyle(option: option, primaryColor: primary, onPrimaryColor: onPrimary))
        case .emphasized:
            self.buttonStyle(EmphasizedButtonStyle(option: option, primaryColor: primary, onPrimaryColor: onPrimary))
        case .small:
            self.buttonStyle(SmallButtonStyle(option: option, primaryColor: primary, onPrimaryColor: onPrimary))
        }
    }
}

#Preview {
    Button(action: {}) {
        Text("Test")
    }
    .buttonStyle(type: .small, option: .fiilled, primary: ColorTheme._default.error, onPrimary: ColorTheme._default.onError)
}
