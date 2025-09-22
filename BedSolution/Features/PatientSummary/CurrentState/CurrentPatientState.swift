//
//  CurrentPatient.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct CurrentPatientState: View {
    @Environment(\.theme) private var theme
    @Environment(PatientInfoController.self) var patientInfo
    @State private var controller = TodayDayLogController()
    @State private var selectedPostureLog: PostureLog?
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 6) {
                if false {
                    PostureAlert(region: "엉덩뼈", onRecord: {})
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                        .transition(.scale)
                }
                if let lastLog = controller.pressureLogs.last {
                    PatientStatusCard(
                        name: patientInfo.name,
                        occiputTime: patientInfo.occiputTime,
                        scapulaTime: patientInfo.scapulaTime,
                        elbowTime: patientInfo.elbowTime,
                        hipTime: patientInfo.hipTime,
                        heelTime: patientInfo.heelTime,
                        pressureLog: lastLog
                    )
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .scrollDismissAnimation()
                    AccumulatedPressureCard(
                        pressureLog: lastLog,
                        occiputTime: patientInfo.occiputTime,
                        scapulaTime: patientInfo.scapulaTime,
                        elbowTime: patientInfo.elbowTime,
                        hipTime: patientInfo.hipTime,
                        heelTime: patientInfo.heelTime
                    )
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .scrollDismissAnimation()
                } else {
                    NoDayLogView()
                }
                
                if !controller.pressureLogs.isEmpty {
                    Section {
                        Text("자세 변경 이력")
                            .textStyle(theme.textTheme.emphasizedTitleMedium)
                            .foregroundColorSet(theme.colorTheme.onSurface)
                        ForEach(controller.pressureLogs) { pressureLog in
                            PressureLogCell(log: pressureLog, onSelect: {})
                        }
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
        .onChange(of: patientInfo.deviceID) { _, deviceID in
            Task { await controller.initialize(deviceID: deviceID) }
        }
        .task {
            await controller.initialize(deviceID: patientInfo.deviceID)
        }
    }
}

private struct NoDayLogView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: 0) {
            Image(.deviceSync)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColorSet(theme.colorTheme.primary)
                .frame(height: 200)
            Group {
                Text("아직 압력 기록이 없습니다.")
                Text("장치가 사용자와 연결이 되었는지 확인해주세요.")
            }
            .textStyle(theme.textTheme.emphasizedLabelLarge)
            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 10, leading: 8, bottom: 10, trailing: 8))
        .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    CurrentPatientState()
        .environment(PatientInfoController())
}
