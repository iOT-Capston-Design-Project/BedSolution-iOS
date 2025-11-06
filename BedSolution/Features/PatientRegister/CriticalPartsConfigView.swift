//
//  PatientConfigView.swift
//  BedSolution
//
//  Created by 이재호 on 8/7/25.
//

import SwiftUI

struct CriticalPartsConfigView: View {
    @Environment(\.theme) private var theme
    @Binding var occiputhThreshold: Int?
    @Binding var scapulaThreshold: Int?
    @Binding var rightElbowThreshold: Int?
    @Binding var leftElbowThreshold: Int?
    @Binding var hipThreshold: Int?
    @Binding var rightHeelThreshold: Int?
    @Binding var leftHeelThreshold: Int?
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 25) {
                Text("주의해야 할 부위를 탭하여 선택해주세요")
                    .textStyle(theme.textTheme.emphasizedTitleMedium)
                    .foregroundColorSet(theme.colorTheme.onSurface)
                CriticalPartConfigSelector(
                  occiputTime: $occiputhThreshold,
                  scapulaTime: $scapulaThreshold,
                  rightElbowTime: $rightElbowThreshold,
                  leftElbowTime: $leftElbowThreshold,
                  hipTime: $hipThreshold,
                  rightHeelTime: $rightHeelThreshold,
                  leftHeelTime: $leftHeelThreshold
                )
            }
            Spacer()
            Button(action: onNext) {
                Text("다음")
                    .textStyle(theme.textTheme.emphasizedBodyLarge)
                    .frame(width: 250)
            }
            .buttonStyle(type: .emphasized, option: .fiilled, primary: theme.colorTheme.primary, onPrimary: theme.colorTheme.onPrimary)
        }
        .padding(EdgeInsets(top: 0, leading: 25, bottom: 30, trailing: 25))
    }
}

#Preview {
    @Previewable @State var occiputThreshold: Int?
    @Previewable @State var scapulaThreshold: Int?
    @Previewable @State var rightElbowThreshold: Int?
    @Previewable @State var leftElbowThreshold: Int?
    @Previewable @State var hipThreshold: Int?
    @Previewable @State var rightHeelThreshold: Int?
    @Previewable @State var leftHeelThreshold: Int?
    CriticalPartsConfigView(
      occiputhThreshold: $occiputThreshold,
      scapulaThreshold: $scapulaThreshold,
      rightElbowThreshold: $rightElbowThreshold,
      leftElbowThreshold: $leftElbowThreshold,
      hipThreshold: $hipThreshold,
      rightHeelThreshold: $rightHeelThreshold,
      leftHeelThreshold: $leftHeelThreshold,
      onNext: {}
    )
}
