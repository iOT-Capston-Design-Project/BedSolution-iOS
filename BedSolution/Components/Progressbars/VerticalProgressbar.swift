//
//  VerticalProgressbar.swift
//  BedSolution
//
//  Created by 이재호 on 7/28/25.
//

import Foundation
import SwiftUI

struct VerticalProgressbar: View {
    @Environment(\.theme) private var theme
    var color: ColorSet
    var progress: Double
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<10) { idx in
                Capsule()
                    .frame(width: 2)
                    .foregroundColorSet(Double(idx)/10 <= progress ? color: theme.colorTheme.surfaceContainer)
            }
        }
        .frame(maxHeight: 38)
    }
}

#Preview {
    VerticalProgressbar(color: ColorTheme._default.primary, progress: 0.5)
}
