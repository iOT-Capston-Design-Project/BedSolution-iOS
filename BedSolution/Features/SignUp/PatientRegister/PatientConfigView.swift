//
//  PatientConfigView.swift
//  BedSolution
//
//  Created by 이재호 on 8/7/25.
//

import SwiftUI

struct PatientConfigView: View {
    @Environment(\.theme) private var theme
    @Binding var cautionOcciput: Bool
    @Binding var cautionScapula: Bool
    @Binding var cautionElbow: Bool
    @Binding var cautionHip: Bool
    @Binding var cautionHeel: Bool
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 25) {
                Text("조심해야 할 부위를 탭하여 선택해주세요")
                    .textStyle(theme.textTheme.emphasizedTitleMedium)
                HumanConfig(
                    cautionOcciput: $cautionOcciput,
                    cautionScapula: $cautionScapula,
                    cautionElbow: $cautionElbow,
                    cautionHip: $cautionHip,
                    cautionHeel: $cautionHeel
                )
                Text("선택된 부위는 더 세심히 관찰되고 긴급 알림을 받을 수 있어요")
                    .frame(width: 250)
                    .multilineTextAlignment(.center)
                    .textStyle(theme.textTheme.bodyLarge)
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
    @Previewable @State var cautionOcciput: Bool = false
    @Previewable @State var cautionScapula: Bool = false
    @Previewable @State var cautionElbow: Bool = false
    @Previewable @State var cautionHip: Bool = false
    @Previewable @State var cautionHeel: Bool = false
    PatientConfigView(cautionOcciput: $cautionOcciput, cautionScapula: $cautionScapula, cautionElbow: $cautionElbow, cautionHip: $cautionHip, cautionHeel: $cautionHeel, onNext: {})
}
