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
    @State private var step = RegisterStep.name
    @State private var name: String = ""
    @State private var weight: Int = 15
    @State private var cautionOcciput: Bool = false
    @State private var cautionScapula: Bool = false
    @State private var cautionElbow: Bool = false
    @State private var cautionHip: Bool = false
    @State private var cautionHeel: Bool = false
    @State private var onRegistering = false
    @State private var registerFailed: Bool = false
    
    private enum RegisterStep: CaseIterable {
        case name, weight, caution, registering
        
        var step: Double {
            switch self {
            case .name:
                0.1
            case .weight:
                0.45
            case .caution:
                0.70
            case .registering:
                1
            }
        }
        var name: LocalizedStringResource {
            switch self {
            case .name:
                "환자명"
            case .weight:
                "몸무게"
            case .caution:
                "주요부위"
            case .registering:
                "등록완료"
            }
        }
    }
    
    private var stepInfo: some View {
        HorizontalProgressbar(color: theme.colorTheme.secondary, progress: step.step)
            .overlay {
                HStack(spacing: 0) {
                    ForEach(RegisterStep.allCases, id: \.self) { step in
                        Text(step.name)
                            .textStyle(theme.textTheme.emphasizedLabelLarge)
                            .foregroundColorSet(step == self.step ? theme.colorTheme.primary: theme.colorTheme.onSurfaceVarient)
                            .onTapGesture {
                                if self.step != .registering && self.step.step > step.step {
                                    withAnimation { self.step = step }
                                }
                            }
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
                switch step {
                case .name:
                    PatientNameEditView(
                        name: $name,
                        onNext: { withAnimation { self.step = .weight } }
                    )
                    .transition(.blurReplace)
                case .weight:
                    PatientWeightEditView(
                        weight: $weight,
                        onNext: { withAnimation { self.step = .caution } }
                    )
                    .transition(.blurReplace)
                case .caution:
                    PatientConfigView(
                        cautionOcciput: $cautionOcciput,
                        cautionScapula: $cautionScapula,
                        cautionElbow: $cautionElbow,
                        cautionHip: $cautionHip,
                        cautionHeel: $cautionHeel,
                        onNext: {
                            withAnimation { self.step = .registering }
                        }
                    )
                    .transition(.blurReplace)
                case .registering:
                    PatientRegisteringView(
                        name: name,
                        weight: weight,
                        cautionOcciput: cautionOcciput, cautionScapula: cautionScapula,
                        cautionElbow: cautionElbow, cautionHip: cautionHip,
                        cautionHeel: cautionHeel, onRegistering: onRegistering,
                        onStart: { dismiss() }
                    )
                    .transition(.blurReplace)
                    .onAppear {
                        registerPatient()
                    }
                }
            }
        }
        .navigationTitle(Text("환자 등록"))
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled(step == .registering)
        .alert("등록 실패", isPresented: $registerFailed) {
            Button(action: { withAnimation { self.step = .caution } }) {
                Text("확인")
            }
        } message: {
            Text("환자 정보를 등록하는데 실패하였습니다. 재시도해주세요.")
        }
    }
    
    private func registerPatient() {
        onRegistering = true
        Task {
            let isRegistered = await AuthController.shared.registerPatient(
                name: name, weight: weight,
                cautionOcciput: cautionOcciput, cautionScapula: cautionScapula,
                cautionElbow: cautionElbow, cautionHip: cautionHip, cautionHeel: cautionHeel
            )
            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .seconds(2))) {
                self.onRegistering = false
                if !isRegistered {
                    self.registerFailed = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        PatientRegisterView()
    }
}
