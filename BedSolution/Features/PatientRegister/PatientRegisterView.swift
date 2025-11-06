//
//  PatientRegisterView.swift
//  BedSolution
//
//  Created by 이재호 on 8/7/25.
//

import SwiftUI

struct PatientRegisterView: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @Environment(AuthService.self) private var auth
    @State private var controller = PatientRegisterController()
    
    var body: some View {
      ZStack {
          switch controller.currentStep {
          case .name:
              PatientNameEditView(
                  name: $controller.name,
                  onNext: controller.nextStep
              )
              .transition(.blurReplace)
          case .weight:
              PatientWeightEditView(
                  weight: $controller.weight,
                  onNext: controller.nextStep
              )
              .transition(.blurReplace)
          case .caution:
            CriticalPartsConfigView(
              occiputhThreshold: $controller.occipuThresold,
              scapulaThreshold: $controller.scapulThreshold,
              rightElbowThreshold: $controller.rightElbowThreshold,
              leftElbowThreshold: $controller.leftElbowThreshold,
              hipThreshold: $controller.hipThreshold,
              rightHeelThreshold: $controller.rightHeelThreshold,
              leftHeelThreshold: $controller.leftHeelThreshold,
              onNext: controller.nextStep
            )
            .transition(.blurReplace)
          case .registering:
              PatientRegisteringView(
                  name: controller.name,
                  weight: controller.weight,
                  occiputThreshold: controller.occipuThresold,
                  scapulaThreshold: controller.scapulThreshold,
                  rightElbowThreshold: controller.rightElbowThreshold,
                  leftElbowThreshold: controller.leftElbowThreshold,
                  hipThreshold: controller.hipThreshold,
                  rightHeelThreshold: controller.rightHeelThreshold,
                  leftHeelThreshold: controller.leftHeelThreshold,
                  onRegistering: controller.isRegistering,
                  onStart: { dismiss() }
              )
              .transition(.blurReplace)
              .onAppear {
                  controller.register(uid: auth.uid)
              }
          }
      }
        .animation(.default, value: controller.currentStep)
        .navigationTitle(Text(controller.currentStep.name))
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled(!controller.dismissEnabled)
        .alert("등록 실패", isPresented: $controller.isFailed) {
            Button(action: controller.backStep) {
                Text("확인")
            }
        } message: {
            Text("환자 정보를 등록하는데 실패하였습니다. 재시도해주세요.")
        }
    }
}

#Preview {
    NavigationStack {
        PatientRegisterView()
    }
}
