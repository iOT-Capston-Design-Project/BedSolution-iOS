//
//  PostureChangeLogCell.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct PostureLogCell: View {
    @Environment(\.theme) private var theme
    var postureLog: PostureLog
    var onSelect: ()->Void
    
    var body: some View {
        HStack {
            Text(postureLog.createdAt, format: .dateTime.hour(.twoDigits(amPM: .wide)).minute(.twoDigits))
                .textStyle(theme.textTheme.emphasizedTitleSmall)
                .foregroundColorSet(theme.colorTheme.onSurface)
            Spacer()
            Button(action: onSelect) {
                Text("자세 확인")
                    .textStyle(theme.textTheme.emphasizedLabelLarge)
            }
            .buttonStyle(type: .small, option: .fiilled, primary: theme.colorTheme.secondaryContainer, onPrimary: theme.colorTheme.onSecondaryContainer)
        }
        .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
        .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    PostureLogCell(postureLog: PostureLog(id: 0, createdAt: .now, memo: "TEST", dayID: 0, patientID: 0), onSelect: {})
}
