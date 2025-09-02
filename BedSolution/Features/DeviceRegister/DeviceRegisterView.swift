//
//  DeviceRegisterView.swift
//  BedSolution
//
//  Created by 이재호 on 9/1/25.
//

import SwiftUI

struct DeviceRegisterView: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var controller = DeviceRegisterController()
    @State private var textWidth: CGFloat = 55
    @State private var onError: Bool = false
    private let horizontalPadding: CGFloat = 25
    private var isEmpty: Bool {
        controller.deviceID == 0
    }
    var patient: Patient
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                if controller.current == .enterDeviceID || controller.current == .registrationFailed {
                    VStack {
                        Text("장치 ID를 입력해주세요")
                            .textStyle(theme.textTheme.emphasizedTitleMedium)
                        VStack(spacing: 15) {
                            ZStack {
                                Text(isEmpty ? "장치 ID": String(controller.deviceID))
                                    .textStyle(theme.textTheme.emphasizedDisplaySmall)
                                    .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                                    .background {
                                        GeometryReader { proxy in
                                            Color.clear
                                                .onAppear { textWidth = proxy.size.width }
                                                .onChange(of: controller.deviceID) { _, _ in textWidth = proxy.size.width }
                                        }
                                    }
                                    .opacity(isEmpty ? 0.4: 0)
                                TextField("", text: Binding<String>(
                                    get: { isEmpty ? "": String(controller.deviceID) },
                                    set: {
                                        if let intValue = Int($0) {
                                            controller.deviceID = intValue
                                        }
                                    })
                                )
                                .keyboardType(.numberPad)
                                .labelsHidden()
                                .lineLimit(1)
                                .textStyle(theme.textTheme.emphasizedDisplaySmall)
                                .frame(width: min(max(textWidth, 55), 250), alignment: .leading)
                                .disabled(controller.current == .waitingForRegistration)
                                
                            }
                            Rectangle()
                                .frame(width: min(textWidth+horizontalPadding, 250), height: 3)
                                .foregroundColorSet(isEmpty ? theme.colorTheme.outline: theme.colorTheme.primary)
                        }
                    }
                }
                if controller.current == .registrationSuccess {
                    
                }
                if controller.current == .waitingForRegistration {
                    HStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                        Text("장치 연결 중")
                            .textStyle(theme.textTheme.bodyLarge)
                            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                    }
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                    .transition(.scale)
                }
                Spacer()
                Button(action: {
                    if controller.current == .registrationSuccess {
                        dismiss()
                    } else {
                        controller.register(patient: patient)
                    }
                }) {
                    Text(controller.current == .registrationSuccess ? "닫기" : "등록")
                        .textStyle(theme.textTheme.emphasizedBodyLarge)
                        .frame(width: 250)
                }
                .buttonStyle(type: .emphasized, option: .fiilled, primary: theme.colorTheme.primary, onPrimary: theme.colorTheme.onPrimary)
                .disabled(isEmpty || controller.current == .waitingForRegistration)
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 0, leading: 25, bottom: 30, trailing: 25))
            .backgroundColorSet(theme.colorTheme.surface)
            .animation(.default, value: controller.current)
            .navigationTitle(Text("장치 등록"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled(controller.current == .waitingForRegistration)
        .alert("장치 등록 실패", isPresented: $onError, actions: {}) {
            Text("장치(\(controller.deviceID))를 찾을 수 없습니다.")
        }
        .onChange(of: controller.current) { _, state in
            if state == .registrationFailed {
                onError = true
            }
        }
    }
}

#Preview {
    DeviceRegisterView(patient: Patient(id: 123, createdAt: .now, uid: UUID(), name: "", cautionOcciput: false, cautionScapula: false, cautionElbow: false, cautionHip: false, cautionHeel: false))
}
