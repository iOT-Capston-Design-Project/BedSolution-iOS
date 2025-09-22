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
    
    private var stepInfo: some View {
        HorizontalProgressbar(color: theme.colorTheme.secondary, progress: controller.currentStep.step)
            .overlay {
                HStack(spacing: 0) {
                    ForEach(PatientRegisterStep.allCases, id: \.self) { step in
                        Text(step.name)
                            .textStyle(theme.textTheme.emphasizedLabelLarge)
                            .foregroundColorSet(controller.currentStep == step ? theme.colorTheme.primary: theme.colorTheme.onSurfaceVarient)
                            .frame(maxWidth: .infinity)
                    }
                }
                .offset(y: 15)
            }
    }
    
    var body: some View {
        VStack {
            stepInfo
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
                    PatientConfigView(
                        occiputTime: $controller.occiputTime,
                        scapulaTime: $controller.scapulaTime,
                        elbowTime: $controller.elbowTime,
                        hipTime: $controller.hipTime,
                        heelTime: $controller.heelTime,
                        onNext: controller.nextStep
                    )
                    .transition(.blurReplace)
                case .registering:
                    PatientRegisteringView(
                        name: controller.name,
                        weight: controller.weight,
                        occiputTime: controller.occiputTime, scapulaTime: controller.scapulaTime,
                        elbowTime: controller.elbowTime, hipTime: controller.hipTime,
                        heelTime: controller.heelTime, onRegistering: controller.isRegistering,
                        onStart: { dismiss() }
                    )
                    .transition(.blurReplace)
                    .onAppear {
                        controller.register(uid: auth.uid)
                    }
                }
            }
        }
        .animation(.default, value: controller.currentStep)
        .navigationTitle(Text("환자 등록"))
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
