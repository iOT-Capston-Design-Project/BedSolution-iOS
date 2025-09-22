//
//  PressureLogCell.swift
//  BedSolution
//
//  Created by 이재호 on 9/19/25.
//

import SwiftUI

struct PressureLogCell: View {
    @Environment(\.theme) private var theme
    var log: PressureLog
    var onSelect: ()->Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(log.createdAt, format: .dateTime.hour().minute().second())
                    .textStyle(theme.textTheme.emphasizedBodyLarge)
                HStack(spacing: 5) {
                    Text("뒤통수: \(TimeFormatter.formattedDuration(from: Int(log.occiput/60)))")
                    Text("견갑골: \(TimeFormatter.formattedDuration(from: Int(log.scapula/60)))")
                    Text("팔꿈치: \(TimeFormatter.formattedDuration(from: Int(log.elbow/60)))")
                }
                .textStyle(theme.textTheme.labelLarge)
                .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                
                HStack(spacing: 5) {
                    Text("엉덩뼈: \(TimeFormatter.formattedDuration(from: Int(log.hip/60)))")
                    Text("발꿈치: \(TimeFormatter.formattedDuration(from: Int(log.heel/60)))")
                }
                .textStyle(theme.textTheme.labelLarge)
                .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
            }
            Spacer()
            Button(action: onSelect) {
                Label("기록하기", systemImage: "camera")
                    .textStyle(theme.textTheme.emphasizedLabelLarge)
            }
            .buttonStyle(type: .chip, option: .fiilled, primary: theme.colorTheme.tertiary, onPrimary: theme.colorTheme.onTertiary)
        }
        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
        .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    PressureLogCell(log: PressureLog(id: 0, createdAt: .now, occiput: 60*100, scapula: 60*100, elbow: 60*110, heel: 60*15, hip: 60*40, dayID: 0, postureType: .UKNOWN), onSelect: {})
}
