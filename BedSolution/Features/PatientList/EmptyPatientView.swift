//
//  EmptyPatientView.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//

import SwiftUI

struct EmptyPatientView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack {
            Image(.noPatients)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColorSet(theme.colorTheme.onSurface)
            Text("등록된 환자가 없습니다")
                .textStyle(theme.textTheme.bodyLarge)
                .foregroundColorSet(theme.colorTheme.onSurface)
        }
    }
}

#Preview {
    EmptyPatientView()
}
