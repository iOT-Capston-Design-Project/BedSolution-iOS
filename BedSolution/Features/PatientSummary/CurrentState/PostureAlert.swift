//
//  PostureAlert.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct PostureAlert: View {
    @Environment(\.theme) private var theme
    @Environment(PatientInfoController.self) private var patientInfo
    var log: PressureLog
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColorSet(theme.colorTheme.error)
                .font(.system(size: 20))
            VStack(alignment: .trailing, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text("자세 변경 요청")
                            .textStyle(theme.textTheme.emphasizedTitleMedium)
                            .foregroundColorSet(theme.colorTheme.error)
                        Spacer()
                        Text(Date.now, format: .dateTime)
                            .textStyle(theme.textTheme.labelMedium)
                            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                    }
                    Text(dagenrousPartsStr())
                        .textStyle(theme.textTheme.bodyLarge)
                }
            }
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 10, trailing: 8))
        .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func dagenrousPartsStr() -> String {
        var result: String = ""
        if let occiputTime = patientInfo.occiputTime, log.occiput/60 >= occiputTime {
            result.append("뒤통수")
        }
        if let scapulaTime = patientInfo.scapulaTime, log.scapula/60 >= scapulaTime {
            if !result.isEmpty { result.append(", ") }
            result.append("견갑골")
        }
        if let hipTime = patientInfo.hipTime, log.hip/60 >= hipTime {
            if !result.isEmpty { result.append(", ") }
            result.append("엉덩뼈")
        }
        if let elbowTime = patientInfo.elbowTime, log.elbow/60 >= elbowTime {
            if !result.isEmpty { result.append(", ") }
            result.append("팔꿈치")
        }
        if let heelTime = patientInfo.heelTime, log.heel/60 >= heelTime {
            if !result.isEmpty { result.append(", ") }
            result.append("발꿈치")
        }
        if !result.isEmpty {
            result.append("에 지속적인 압력이 가해지고 있습니다.")
        }
        return result
    }
}

#Preview {
    PostureAlert(log: PressureLog())
        .environment(PatientInfoController())
}
