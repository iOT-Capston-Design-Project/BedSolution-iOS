//
//  NoPatientSelectionView.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//

import SwiftUI

struct NoPatientSelectionView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        Text("환자를 선택해주세요")
            .textStyle(theme.textTheme.bodyLarge)
            .foregroundColorSet(theme.colorTheme.onSurface)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .backgroundColorSet(theme.colorTheme.surfaceContainerHigh)
    }
}

#Preview {
    NoPatientSelectionView()
}
