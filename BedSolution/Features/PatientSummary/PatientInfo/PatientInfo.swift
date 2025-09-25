//
//  PatientInfo.swift
//  BedSolution
//
//  Created by 이재호 on 8/15/25.
//

import SwiftUI

struct PatientInfo: View {
    private enum FieldStyle {
        case single, top, middle, bottom
        case custom(CGFloat, CGFloat, CGFloat, CGFloat) // TL TR BL BR
    }
    private enum TargetParts {
        case none, occiput, scapula, elbow, hip, heel
    }
    @Environment(\.theme) private var theme
    @Bindable var controller: PatientInfoController
    @State private var deviceEditAlert: Bool = false
    @State private var showDeviceEditor: Bool = false
    @State private var targetedPart: TargetParts = .none
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                fieldSection(axis: .vertical) {
                    field(label: "환자명", style: .top) {
                        TextField("환자명", text: $controller.name)
                            .labelsHidden()
                            .textStyle(theme.textTheme.bodyLarge)
                            .multilineTextAlignment(.trailing)
                    }
                    field(label: "연결된 장치", style: .bottom) {
                        VStack(alignment: .trailing) {
                            HStack {
                                TextField(
                                    "장치 ID",
                                    text: Binding<String>(
                                        get: { String(controller.deviceID ?? 0) },
                                        set: { value in
                                            if let iVal = Int(value), iVal != 0 {
                                                controller.deviceID = iVal
                                            } else {
                                                controller.deviceID = nil
                                            }
                                        }
                                    )
                                )
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .textStyle(theme.textTheme.bodyLarge)
                                .onSubmit {
                                    controller.checkDeviceID()
                                }
                                if controller.deviceIDState == .checking {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                            }
                            if controller.deviceIDState == .invalid {
                                Text("올바르지 않은 ID입니다.")
                                    .textStyle(theme.textTheme.emphasizedLabelLarge)
                                    .foregroundColorSet(theme.colorTheme.error)
                            }
                        }
                        .animation(.default, value: controller.deviceIDState)
                    }
                }
                fieldSection {
                    field(label: "몸무게", style: .single) {
                        HStack(spacing: 8) {
                            Text(String(format: "%.1f kg", controller.weight ?? 0))
                                .textStyle(theme.textTheme.bodyLarge)
                                .foregroundColorSet(theme.colorTheme.onSurface)
                                .contentTransition(.numericText(value: Double(controller.weight ?? 0)))
                                .animation(.default, value: controller.weight)
                            Stepper(
                                "몸무게",
                                value: Binding<Float>(get: { controller.weight ?? 0 }, set: { controller.weight = $0 }),
                                in: 14...120
                            )
                            .labelsHidden()
                        }
                    }
                }
                fieldSection(axis: .vertical) {
                    field(
                        label: "주요 알림 부위",
                        axis: .vertical,
                        style: .top
                    ) {
                        HumanConfig(
                            occiputTime: $controller.occiputTime,
                            scapulaTime: $controller.scapulaTime,
                            elbowTime: $controller.elbowTime,
                            hipTime: $controller.hipTime,
                            heelTime: $controller.heelTime
                        )
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    }
                    fieldSection {
                        field(
                            label: "뒤통수",
                            style: .middle
                        ) {
                            timeButton(target: .occiput, time: controller.occiputTime)
                        }
                        if targetedPart == .occiput {
                            field(label: "최대 압력 시간", axis: .vertical, style: .middle) {
                                PressureTimePicker(time: $controller.occiputTime)
                            }
                        }
                        field(label: "견갑골", style: .middle) {
                            timeButton(target: .scapula, time: controller.scapulaTime)
                        }
                        if targetedPart == .scapula {
                            field(label: "최대 압력 시간", axis: .vertical, style: .middle) {
                                PressureTimePicker(time: $controller.scapulaTime)
                            }
                        }
                        field(label: "팔꿈치", style: .middle) {
                            timeButton(target: .elbow, time: controller.elbowTime)
                        }
                        if targetedPart == .elbow {
                            field(label: "최대 압력 시간", axis: .vertical, style: .middle) {
                                PressureTimePicker(time: $controller.elbowTime)
                            }
                        }
                        field(label: "엉덩뼈", style: .middle) {
                            timeButton(target: .hip, time: controller.hipTime)
                        }
                        if targetedPart == .hip {
                            field(label: "최대 압력 시간", axis: .vertical, style: .middle) {
                                PressureTimePicker(time: $controller.hipTime)
                            }
                        }
                        field(
                            label: "발꿈치",
                            style: targetedPart == .heel ? .middle: .bottom
                        ) {
                            timeButton(target: .heel, time: controller.heelTime)
                        }
                        if targetedPart == .heel {
                            field(label: "최대 압력 시간", axis: .vertical, style: .bottom) {
                                PressureTimePicker(time: $controller.heelTime)
                            }
                        }
                    }
                    .animation(.default, value: targetedPart)
                }
            }
        }
        .contentMargins(.horizontal, 12, for: .scrollContent)
        .contentMargins(.top, 5, for: .scrollContent)
        .scrollIndicators(.never)
        .safeAreaInset(edge: .bottom) {
            if controller.isUpdated {
                Button(action: { Task { await self.controller.update() } }) {
                    HStack(spacing: 5) {
                        if controller.state.isUpdating {
                            ProgressView()
                                .progressViewStyle(.circular)
                        }
                        Text("변경사항 저장하기")
                            .textStyle(theme.textTheme.emphasizedLabelLarge)
                    }
                }
                .buttonStyle(type: .small, option: .fiilled, primary: theme.colorTheme.primary, onPrimary: theme.colorTheme.onPrimary)
                .disabled(controller.state.isUpdating || controller.deviceIDState != .valid)
                .shadow(radius: 10)
                .transition(.scale)
            }
        }
        .animation(.default, value: controller.isUpdated)
    }

    
    @ViewBuilder
    private func field<V: View>(
        label: LocalizedStringResource,
        axis: Axis = .horizontal,
        style: FieldStyle = .single,
        expand: Bool = false,
        @ViewBuilder content: () -> V
    ) -> some View {
        let tl: CGFloat = switch style {
        case .single:
            15
        case .top:
            15
        case .middle:
            0
        case .bottom:
            0
        case .custom(let radius, _, _, _):
            radius
        }
        let tr: CGFloat = switch style {
        case .single:
            15
        case .top:
            15
        case .middle:
            0
        case .bottom:
            0
        case .custom(_, let radius, _, _):
            radius
        }
        let bl: CGFloat = switch style {
        case .single:
            15
        case .top:
            0
        case .middle:
            0
        case .bottom:
            15
        case .custom(_, _, let radius, _):
            radius
        }
        let br: CGFloat = switch style {
        case .single:
            15
        case .top:
            0
        case .middle:
            0
        case .bottom:
            15
        case .custom(_, _, _, let radius):
            radius
        }
        let layout = switch axis {
        case .horizontal:
            AnyLayout(HStackLayout(spacing: 0))
        case .vertical:
            AnyLayout(VStackLayout(alignment: .leading, spacing: 5))
        }
        layout {
            Text(label)
                .textStyle(theme.textTheme.emphasizedTitleMedium)
                .foregroundColorSet(theme.colorTheme.onSurface)
            if axis == .horizontal {
                Spacer()
            }
            content()
        }
        .padding(EdgeInsets(top: 8, leading: 17, bottom: 8, trailing: 17))
        .frame(minHeight: 50, maxHeight: expand ? .infinity: nil)
        .backgroundColorSet(
            theme.colorTheme.surfaceContainer,
            in: RoundedCorner(
                tl: tl,
                tr: tr,
                bl: bl,
                br: br
            )
        )
    }
    
    @ViewBuilder
    private func fieldSection<V: View>(axis: Axis = .vertical, @ViewBuilder content: ()->V) -> some View {
        let layout = switch axis {
        case .horizontal:
            AnyLayout(HStackLayout(spacing: 0))
        case .vertical:
            AnyLayout(VStackLayout(spacing: 0))
        }
        layout {
            Group(subviews: content()) { collection in
                if let first = collection.first {
                    first
                }
                ForEach(collection.dropFirst()) { subview in
                    switch axis {
                    case .horizontal:
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColorSet(theme.colorTheme.outline)
                    case .vertical:
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColorSet(theme.colorTheme.outline)
                    }
                    subview
                }
            }
        }
    }
    
    private func timeButton(target: TargetParts, time: Int?) -> some View {
        Button(action: {
            targetedPart = targetedPart == target ? .none: target
        }) {
            Group {
                if let time {
                    Text(TimeFormatter.formattedDuration(from: time))
                } else {
                    Text("설정하기")
                }
            }
            .textStyle(theme.textTheme.labelLarge)
            .foregroundColorSet(controller.occiputTime != nil ? theme.colorTheme.onSurfaceVarient: theme.colorTheme.primary)
        }
    }
}

private struct RoundedCorner: InsettableShape {
    var tl: CGFloat
    var tr: CGFloat
    var bl: CGFloat
    var br: CGFloat
    
    nonisolated func path(in rect: CGRect) -> Path {
        var path = Path()
    
        path.move(to: CGPoint(x: rect.minX + tl, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + tr),
                          control: CGPoint(x: rect.maxX, y: rect.minY))
            
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - br))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - br, y: rect.maxY),
                          control: CGPoint(x: rect.maxX, y: rect.maxY))
            
        path.addLine(to: CGPoint(x: rect.minX + bl, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - bl),
                          control: CGPoint(x: rect.minX, y: rect.maxY))
            
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        path.addQuadCurve(to: CGPoint(x: rect.minX + tl, y: rect.minY),
                          control: CGPoint(x: rect.minX, y: rect.minY))
            
        return path
    }
    
    nonisolated func inset(by amount: CGFloat) -> some InsettableShape {
        return RoundedCorner(
            tl: tl - amount,
            tr: tr - amount,
            bl: bl - amount,
            br: br - amount
        )
    }
}

#Preview {
    PatientInfo(controller: PatientInfoController())
        .background(Color.black)
}
