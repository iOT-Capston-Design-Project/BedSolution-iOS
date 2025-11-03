//
//  PatientInfoView.swift
//  BedSolution
//
//  Created by 이재호 on 11/1/25.
//

import SwiftUI

struct PatientInfoView: View {
  @Environment(\.theme) private var theme
  @State private var vm = PatientInfoViewModel()
  @State private var errorAlert = false
  var patient: Patient
  
  var body: some View {
    ScrollView {
      LazyVStack {
        PatientInfoWidget(name: $vm.name, weight: $vm.weight)
        LinkedDeviceWidget(deviceID: $vm.deviceID)
        CriticalThresholdWidget(
          occiputTime: $vm.occiputTime,
          scapulaTime: $vm.scapulaTime,
          rightElbowTime: $vm.rightElbowTime,
          leftElbowTime: $vm.leftElbowTime,
          hipTime: $vm.hipTime,
          rightHeelTime: $vm.rightHeelTime,
          leftHeelTime: $vm.leftHeelTime
        )
      }
    }
    .contentMargins(.horizontal, 10)
    .contentMargins(.top, 6)
    .scrollContentBackground(.hidden)
    .backgroundColorSet(theme.colorTheme.surface)
    .navigationTitle(Text(vm.name))
    .alert(
      isPresented: $errorAlert,
      error: vm.error,
      actions: { _ in },
      message: { error in
        Text(errorMessage(error: error))
      }
    )
    .toolbar {
      ToolbarItem {
        Button(action: toggleEditMode) {
          if vm.isUpdating {
            ProgressView()
              .progressViewStyle(.circular)
          } else {
            Label(vm.isEditing ? "완료" : "편집", systemImage: vm.isEditing ? "checkmark" : "pencil")
          }
        }
        .tintColorSet(vm.isEditing ? theme.colorTheme.primary: theme.colorTheme.onSurface)
      }
    }
    .toolbarTitleDisplayMode(.inline)
    .environment(vm)
    .onChange(of: vm.error) { _, error in
        errorAlert = error != nil
    }
    .task {
      await vm.initialize(patientID: patient.id, uid: patient.uid)
    }
  }
  
  private func toggleEditMode() {
    if vm.isEditing {
      Task {
        await vm.update()
      }
    }
    withAnimation {
      vm.togglEditigMode()
    }
  }
  
  private func errorMessage(error: Error) -> LocalizedStringResource {
    guard let error = error as? PatientInfoVMError else { return "알 수 없는 오류가 발생했어요." }
    switch error {
    case .fetchPatientFailed:
      return "환자 정보를 불러오는 데 실패했어요."
    case .noPatient:
      return "환자 정보를 찾을 수 없어요."
    case .patientUpdateFailed:
      return "환자 정보를 업데이트하는데 실패했어요."
    case .invalidDevice:
      return "올바르지않은 장치ID에요."
    case .messagingRegistrationFailed:
      return "장치 연동에 실패했어요."
    case .unknown:
      return "알 수 없는 오류가 발생했어요."
    }
  }
}

#Preview {
  NavigationStack {
    PatientInfoView(
      patient: Patient(
        id: 2625083234860015468, createdAt: .now,
        uid: UUID(uuidString: "d9542f41-2177-4522-a833-b48afeff8b19")!,
        name: "",
        occiputTime: nil, scapulaTime: nil, elbowTime: nil, hipTime: nil, heelTime: nil
      )
    )
  }
}
