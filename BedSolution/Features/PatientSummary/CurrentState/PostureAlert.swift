//
//  PostureAlert.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct PostureAlert: View {
    @Environment(\.theme) private var theme
    var region: LocalizedStringResource
    var onRecord: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColorSet(theme.colorTheme.error)
                .font(.system(size: 20))
            VStack(alignment: .trailing, spacing: 10) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text("자세 변경 알림")
                            .textStyle(theme.textTheme.emphasizedTitleMedium)
                            .foregroundColorSet(theme.colorTheme.error)
                        Spacer()
                        Text(Date.now, format: .dateTime)
                            .textStyle(theme.textTheme.labelMedium)
                            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                    }
                    Text("\(region)에 지속적인 압력이 가해지고 있습니다.")
                        .textStyle(theme.textTheme.bodyLarge)
                }
                Button(action: onRecord) {
                    Text("자세 변경 기록하기")
                        .textStyle(theme.textTheme.emphasizedLabelLarge)
                }
                .buttonStyle(type: .small, option: .fiilled, primary: theme.colorTheme.error, onPrimary: theme.colorTheme.onError)
            }
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 10, trailing: 8))
        .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    PostureAlert(region: "엉덩뼈", onRecord: {})
}
