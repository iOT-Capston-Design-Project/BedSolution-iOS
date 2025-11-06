//
//  PatientStatusView.swift
//  BedSolution
//
//  Created by 이재호 on 11/3/25.
//

import SwiftUI

struct PatientStatusView: View {
  @Environment(\.theme) private var theme
  @State private var vm = PatientStatusViewModel()
  var patient: Patient
  
  var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        LazyVStack {
          if vm.isPostureChangeRequired {
            PostureChangeWidget()
              .transition(.scale)
          }
          PatientBodyPressureWidget()
            .animation(.default, value: vm.dayLog)
          
          if !vm.pressureLogs.isEmpty {
            // 오늘 자세 변경 기록
            Section {
              ScrollView(.horizontal) {
                LazyHStack {
                  ForEach(vm.pressureLogs) { pressureLog in
                    PostureLogWidget(pressureLog: pressureLog)
                      .containerRelativeFrame(.horizontal, count: 2, spacing: 0)
                  }
                }
                .scrollTargetLayout()
              }
              .scrollTargetBehavior(.viewAligned)
              .scrollIndicators(.never)
            } header: {
              Text("오늘 자세 변경 기록")
                .textStyle(theme.textTheme.emphasizedTitleMedium)
                .foregroundColorSet(theme.colorTheme.onSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 3, trailing: 0))
            }
          }
        }
        .scrollTargetLayout()
      }
      .scrollTargetBehavior(.viewAligned)
      .scrollIndicators(.never)
      .contentMargins(.horizontal, 10)
      .contentMargins(.vertical, 6)
      .scrollContentBackground(.hidden)
      .backgroundColorSet(theme.colorTheme.surface)
      .navigationTitle(Text("오늘 기록"))
      .navigationSubtitle(Text(vm.name))
      .navigationBarTitleDisplayMode(.inline)
      .animation(.default, value: vm.isPostureChangeRequired)
    }
    .environment(vm)
    .task {
      await vm.initialize(patient: patient)
    }
    .onDisappear {
      vm.cancelPullingTask()
    }
  }
}

#Preview {
  PatientStatusView(
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
