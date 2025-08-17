//
//  CurrentPatient.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct CurrentPatientState: View {
    @Environment(\.theme) private var theme
    @State private var alertPostureWarning: Bool = false
    @State private var postureLogs: [PostureLog] = (0..<20).map { id in
        PostureLog(id: id, createdAt: Calendar.current.date(byAdding: .hour, value: -id, to: .now)!, memo: "TEST \(id)", dayID: 0)
    }
    @State private var selectedPostureLog: PostureLog?
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 6) {
                if alertPostureWarning {
                    PostureAlert(region: "엉덩뼈", onRecord: {})
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .transition(.scale)
                }
                PatientStatusCard()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .scrollDismissAnimation()
                AccumulatedPressureCard()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .scrollDismissAnimation()
                Section {
                    Text("자세 변경 이력")
                        .textStyle(theme.textTheme.emphasizedTitleMedium)
                        .foregroundColorSet(theme.colorTheme.onSurface)
                    ForEach(postureLogs) { postureLog in
                        PostureLogCell(
                            postureLog: postureLog,
                            onSelect: {
                                selectedPostureLog = postureLog
                            }
                        )
                        .scrollDismissAnimation()
                    }
                }
            }
        }
        .contentMargins(.horizontal, 12, for: .scrollContent)
        .contentMargins(.top, 10, for: .scrollContent)
        .scrollIndicators(.never)
        .sheet(item: $selectedPostureLog) { postureLog in
            PostureLogDetail(postureLog: postureLog)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    CurrentPatientState()
}
