//
//  PatientRegisteringView.swift
//  BedSolution
//
//  Created by 이재호 on 8/8/25.
//

import SwiftUI

struct PatientRegisteringView: View {
    @Environment(\.theme) private var theme
    @State private var isAnimating = false
    @State private var patientInfo = [PatientData]()
    @State private var visibleInfo = [PatientData]()
    var name: String = ""
    var weight: Int = 15
    var cautionOcciput: Bool = false
    var cautionScapula: Bool = false
    var cautionElbow: Bool = false
    var cautionHip: Bool = false
    var cautionHeel: Bool = false
    var onRegistering: Bool
    var onStart: () -> Void
    
    private struct PatientData: Identifiable {
        var id: Int
        var title: LocalizedStringResource
        var icon: String
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 35) {
                ZStack {
                    MeshGradient(
                        width: 3,
                        height: 3,
                        points: [
                            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                            [0.0, 0.5], [isAnimating ? 0.1 : 0.8, 0.5], [1.0, isAnimating ? 0.5 : 1],
                            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                        ],
                        colors: [
                            .blue, .white, .purple,
                            isAnimating ? .mint : .blue, isAnimating ? .blue : .mint, .blue,
                            .indigo, .cyan, .mint
                        ]
                    )
                    .clipShape(Circle())
                    Image(systemName: "checkmark")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColorSet(theme.colorTheme.onPrimary)
                        .scaleEffect(CGSize(width: onRegistering ? 0: 1, height: onRegistering ? 0: 1))
                    if onRegistering {
                        StepRotatingCircle(
                            radius: 65,
                            stepAngle: .degrees(60),
                            stepInterval: 1.2,
                            moveDuration: 0.5,
                            onStep: { _ in
                                if patientInfo.count > 3 {
                                    withAnimation {
                                        visibleInfo = patientInfo.randomSample(3)
                                    }
                                }
                            }
                        ) {
                            ForEach(visibleInfo) { info in
                                label(text: info.title, systemImage: info.icon)
                                    .transition(.scale)
                            }
                        }
                        .transition(.scale)
                    }
                }
                .frame(width: 125, height: 125)
                .animation(.default, value: onRegistering)
                
                VStack(spacing: 10) {
                    Text(onRegistering ? "환자 등록 중": "등록 완료")
                        .textStyle(theme.textTheme.emphasizedTitleLarge)
                        .transition(.blurReplace)
                    if !onRegistering {
                        Text("환자 등록이 완료되었습니다.\n바로 시작해 보세요")
                            .multilineTextAlignment(.center)
                            .transition(.blurReplace)
                    }
                }
                .animation(.default, value: onRegistering)
            }
            Spacer()
            Button(action: onStart) {
                Text("시작하기")
                    .textStyle(theme.textTheme.emphasizedBodyLarge)
                    .frame(width: 250)
            }
            .buttonStyle(type: .emphasized, option: .fiilled, primary: theme.colorTheme.primary, onPrimary: theme.colorTheme.onPrimary)
            .disabled(onRegistering)
        }
        .padding(EdgeInsets(top: 0, leading: 25, bottom: 30, trailing: 25))
        .onAppear {
            generatePatientLabels()
            visibleInfo = patientInfo.randomSample(3)
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
    }
    
    @ViewBuilder
    private func label(text: LocalizedStringResource, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .textStyle(theme.textTheme.emphasizedBodyLarge)
            .foregroundColorSet( theme.colorTheme.onSurfaceVarient)
            .padding(EdgeInsets(top: 2, leading: 9, bottom: 2, trailing: 9))
            .backgroundColorSet(theme.colorTheme.surfaceContainer, in: Capsule())
            .overlay {
                Capsule()
                    .stroke(lineWidth: 1)
            }
    }
    
    private func generatePatientLabels() {
        var result = [PatientData]()
        if !name.isEmpty {
            result.append(PatientData(id: 0, title: "\(name)", icon: "person.fill"))
        }
        if weight > 0 {
            result.append(PatientData(id: 1, title: "\(weight) kg", icon: "scalemass.fill"))
        }
        if cautionOcciput {
            result.append(PatientData(id: 2, title: "뒤통수", icon: "exclamationmark.triangle.fill"))
        }
        if cautionScapula {
            result.append(PatientData(id: 3, title: "견갑골", icon: "exclamationmark.triangle.fill"))
        }
        if cautionHip {
            result.append(PatientData(id: 4, title: "엉덩이", icon: "exclamationmark.triangle.fill"))
        }
        if cautionHeel {
            result.append(PatientData(id: 5, title: "발꿈치", icon: "exclamationmark.triangle.fill"))
        }
        if cautionElbow {
            result.append(PatientData(id: 6, title: "팔꿈치", icon: "exclamationmark.triangle.fill"))
        }
        self.patientInfo = result
    }
}


#Preview {
    @Previewable @State var onRegistering = true
    PatientRegisteringView(
        name: "Lee Jaeho",
        weight: 74,
        cautionScapula: true,
        cautionHip: true,
        cautionHeel: true,
        onRegistering: onRegistering,
        onStart: {}
    )
    .onTapGesture {
        onRegistering.toggle()
    }
}
