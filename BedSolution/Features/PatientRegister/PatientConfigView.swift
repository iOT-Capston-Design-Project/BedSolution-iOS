//
//  PatientConfigView.swift
//  BedSolution
//
//  Created by 이재호 on 8/7/25.
//

import SwiftUI

struct PatientConfigView: View {
    @Environment(\.theme) private var theme
    @Binding var occiputTime: Int?
    @Binding var scapulaTime: Int?
    @Binding var elbowTime: Int?
    @Binding var hipTime: Int?
    @Binding var heelTime: Int?
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 25) {
                Text("주의해야 할 부위를 탭하여 선택해주세요")
                    .textStyle(theme.textTheme.emphasizedTitleMedium)
                    .foregroundColorSet(theme.colorTheme.onSurface)
                CriticalPartConfigWidget(
                  occiputTime: $occiputTime,
                  scapulaTime: $scapulaTime,
                  rightElbowTime: $elbowTime,
                  leftElbowTime: $elbowTime,
                  hipTime: $hipTime,
                  rightHeelTime: $heelTime,
                  leftHeelTime: $heelTime
                )
                Text("선택된 부위는 더 짧은 임계시간으로 설정됩니다.")
                    .frame(width: 250)
                    .multilineTextAlignment(.center)
                    .textStyle(theme.textTheme.bodyLarge)
                    .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
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
    @Previewable @State var occiputTime: Int?
    @Previewable @State var scapulaTime: Int?
    @Previewable @State var elbowTime: Int?
    @Previewable @State var hipTime: Int?
    @Previewable @State var heelTime: Int?
    PatientConfigView(occiputTime: $occiputTime, scapulaTime: $scapulaTime, elbowTime: $elbowTime, hipTime: $hipTime, heelTime: $heelTime, onNext: {})
}
