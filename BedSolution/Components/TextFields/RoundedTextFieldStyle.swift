//
//  RoundedTextFieldStyle.swift
//  BedSolution
//
//  Created by 이재호 on 8/6/25.
//

import Foundation
import SwiftUI

private struct RoundedTextFieldStyleModifier: ViewModifier {
    @Environment(\.theme) private var theme
    
    func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
            .frame(minHeight: 40)
            .foregroundColorSet(theme.colorTheme.onSurface)
            .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 8))
    }
}

extension View {
    func roundedTextFieldStyle() -> some View {
        modifier(RoundedTextFieldStyleModifier())
    }
}

#Preview {
    @Previewable @State var text: String = ""
    VStack {
        TextField("Hello", text: $text)
            .roundedTextFieldStyle()
    }
}
