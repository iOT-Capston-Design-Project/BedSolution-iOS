//
//  PostureLogDetail.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//

import SwiftUI

struct PostureLogDetail: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    var postureLog: PostureLog
    
    private var noPostureImg: some View {
        VStack {
            Image(.noPostureLog)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
            Text("자세 이미지가 없습니다")
                .textStyle(theme.textTheme.bodyLarge)
        }
        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        .frame(maxWidth: .infinity)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 19) {
            Text(postureLog.createdAt, format: .dateTime.year().month().day().hour().minute())
                .textStyle(theme.textTheme.emphasizedTitleMedium)
                .frame(height: 45)
            Spacer()
            if let urlStr = postureLog.imgURL {
                AsyncImage(url: URL(string: urlStr)) { img in
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                } placeholder: {
                    noPostureImg
                }
            } else {
                noPostureImg
            }
            Spacer()
            Button(action: { dismiss() }) {
                Text("닫기")
                    .textStyle(theme.textTheme.emphasizedLabelLarge)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(type: .emphasized, option: .fiilled, primary: theme.colorTheme.primary, onPrimary: theme.colorTheme.onPrimary)
        }
        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
        .backgroundColorSet(theme.colorTheme.surface)
    }
}

#Preview {
    PostureLogDetail(
        postureLog: PostureLog(
            id: 0,
            createdAt: .now,
            memo: "TEST MEMO",
            imgURL: "https://thumbs.dreamstime.com/b/young-caucasian-male-patient-bed-talking-to-doctor-hospital-room-young-caucasian-male-patient-bed-talking-to-doctor-169415346.jpg",
            dayID: 0, patientID: 0
        )
    )
}

#Preview {
    PostureLogDetail(
        postureLog: PostureLog(
            id: 0,
            createdAt: .now,
            memo: "TEST MEMO",
            imgURL: nil,
            dayID: 0, patientID: 0
        )
    )
}
