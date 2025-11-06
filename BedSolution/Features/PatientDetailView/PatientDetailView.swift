//
//  PatientDetailView.swift
//  BedSolution
//
//  Created by 이재호 on 11/3/25.
//

import SwiftUI

struct PatientDetailView: View {
  @Environment(\.theme) private var theme
  var patient: Patient
  
  var body: some View {
    TabView {
      Tab("오늘 기록", systemImage: "text.rectangle.page") {
        PatientStatusView(patient: patient)
      }
      Tab("과거 기록", systemImage: "list.bullet.indent") {
        DayLogsView(patient: patient)
      }
      Tab("압력 히트맵", systemImage: "chart.bar.xaxis.ascending") {
        HeatmapView(patient: patient)
      }
      
      Tab("환자 정보", systemImage: "person", role: .search) {
        PatientInfoView(patient: patient)
      }
    }
    .tintColorSet(theme.colorTheme.primary)
  }
}

#Preview {
    PatientDetailView(
      patient: Patient(
        id: 2625083234860015468, createdAt: .now,
        uid: UUID(uuidString: "d9542f41-2177-4522-a833-b48afeff8b19")!,
        name: "",
        occiputThreshold: nil,
        scapulaThreshold: nil,
        rightElbowThreshold: nil,
        leftElbowThreshold: nil,
        hipThreshold: nil,
        rightHeelThreshold: nil,
        leftHeelThreshold: nil
      )
    )
}
