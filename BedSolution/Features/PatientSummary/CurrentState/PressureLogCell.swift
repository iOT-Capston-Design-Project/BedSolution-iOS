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
        VStack(alignment: .leading, spacing: 10) {
            Text("자세: \(log.postureType.title)")
                .textStyle(theme.textTheme.emphasizedTitleMedium)
                .foregroundColorSet(theme.colorTheme.onSurface)
            VStack(alignment: .leading) {
                Group {
                    HStack(spacing: 5) {
                        Text("뒤통수: \(TimeFormatter.formattedDuration(seconds: log.occiput))")
                        Text("견갑골: \(TimeFormatter.formattedDuration(seconds: log.scapula))")
                        Text("팔꿈치: \(TimeFormatter.formattedDuration(seconds: log.elbow))")
                    }
                    HStack(spacing: 5) {
                        Text("엉덩뼈: \(TimeFormatter.formattedDuration(seconds: log.hip))")
                        Text("발꿈치: \(TimeFormatter.formattedDuration(seconds: log.heel))")
                    }
                }
                .textStyle(theme.textTheme.labelLarge)
                .foregroundColorSet(theme.colorTheme.onSurface)
            }
            HStack {
                Spacer()
                Text(log.createdAt, format: .dateTime)
            }
            .textStyle(theme.textTheme.labelMedium)
            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        }
        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
        .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    PressureLogCell(log: PressureLog(id: 0, createdAt: .now, occiput: 60*100, scapula: 60*100, elbow: 60*110, heel: 60*15, hip: 60*40, dayID: 0, postureType: .UKNOWN), onSelect: {})
}
