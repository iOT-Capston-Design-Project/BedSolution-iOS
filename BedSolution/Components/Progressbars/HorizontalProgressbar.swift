//
//  HorizontalProgressbar.swift
//  BedSolution
//
//  Created by 이재호 on 7/28/25.
//

import Foundation
import SwiftUI

struct HorizontalProgressbar: View {
    @Environment(\.theme) private var theme
    var color: ColorSet
    var progress: Double
    private let height: CGFloat = 5
    
    var body: some View {
        Capsule()
            .frame(height: height)
            .foregroundColorSet(theme.colorTheme.surfaceContainer)
            .overlay {
                GeometryReader { proxy in
                    let width = proxy.size.width * CGFloat(self.progress)
                    Capsule()
                        .frame(width: width, height: height)
                        .foregroundColorSet(color)
                }
            }
    }
}

#Preview {
    HorizontalProgressbar(color: ColorTheme._default.error, progress: 0.8)
}
