//
//  PatientLogDetailView.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//

import SwiftUI

struct PatientLogDetailView: View {
    @Environment(\.theme) private var theme
    @State private var postureLogs: [PostureLog] = (0..<20).map { id in
        PostureLog(id: id, createdAt: Calendar.current.date(byAdding: .hour, value: -id, to: .now)!, memo: "TEST \(id)", dayID: 0, patientID: 0)
    }
    @State private var selectedPostureLog: PostureLog?
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 6) {
                    PatientTimeStatus(dayLog: DayLog())
                        .scrollDismissAnimation()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    AccumulatedPressureCard()
                        .scrollDismissAnimation()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
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
            .scrollIndicators(.never)
            .scrollContentBackground(.hidden)
            .backgroundColorSet(theme.colorTheme.surface)
            .navigationTitle(Text(Date.now, format: .dateTime.year().month().day()))
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $selectedPostureLog) { postureLog in
            PostureLogDetail(postureLog: postureLog)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    PatientLogDetailView()
}
