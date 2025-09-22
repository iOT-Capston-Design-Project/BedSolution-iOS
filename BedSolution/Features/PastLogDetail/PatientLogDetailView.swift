//
//  PatientLogDetailView.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//

import SwiftUI

struct PatientLogDetailView: View {
    @Environment(\.theme) private var theme
    @State private var controller: PatientLogDetailController
    @State private var selectedPostureLog: PostureLog?

    init(patient: Patient, dayLog: DayLog) {
        _controller = State(initialValue: PatientLogDetailController(patient: patient, dayLog: dayLog))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 6) {
                    PatientTimeStatus(dayLog: controller.dayLog)
                        .scrollDismissAnimation()
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
//                    AccumulatedPressureCard(pressureLog: )
//                        .scrollDismissAnimation()
//                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    Section {
                        Text("자세 변경 이력")
                            .textStyle(theme.textTheme.emphasizedTitleMedium)
                            .foregroundColorSet(theme.colorTheme.onSurface)
                        ForEach(controller.postureLogs) { postureLog in
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
            .navigationTitle(Text(controller.dayLog.day, format: .dateTime.year().month().day()))
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $selectedPostureLog) { postureLog in
            PostureLogDetail(postureLog: postureLog)
                .presentationDetents([.medium])
        }
        .task { await controller.load() }
    }
}

#Preview {
    PatientLogDetailView(patient: Patient(), dayLog: DayLog())
}
