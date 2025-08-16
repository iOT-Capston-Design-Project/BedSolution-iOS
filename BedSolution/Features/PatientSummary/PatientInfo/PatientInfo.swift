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
    @Environment(\.theme) private var theme
    @State private var patient = Patient(id: 0, createdAt: .now, uid: UUID(), name: "홍길동", cautionOcciput: true, cautionScapula: true, cautionElbow: false, cautionHip: false, cautionHeel: true)
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack {
                field(label: "환자명") {
                    TextField("환자명", text: $patient.name)
                        .labelsHidden()
                        .textStyle(theme.textTheme.bodyLarge)
                        .multilineTextAlignment(.trailing)
                }
                .scrollDismissAnimation()
                fieldSection {
                    field(label: "주요 알림 부위", axis: .vertical, style: .top) {
                        HumanConfig(
                            cautionOcciput: $patient.cautionOcciput,
                            cautionScapula: $patient.cautionScapula,
                            cautionElbow: $patient.cautionElbow,
                            cautionHip: $patient.cautionHip,
                            cautionHeel: $patient.cautionHeel
                        )
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                    }
                    .scrollDismissAnimation()
                    field(label: "뒤통수", style: .middle) {
                        Toggle("뒤통수", isOn: $patient.cautionOcciput)
                            .labelsHidden()
                            .tintColorSet(theme.colorTheme.error)
                    }
                    .scrollDismissAnimation()
                    field(label: "견갑골", style: .middle) {
                        Toggle("견갑골", isOn: $patient.cautionScapula)
                            .labelsHidden()
                            .tintColorSet(theme.colorTheme.error)
                    }
                    .scrollDismissAnimation()
                    field(label: "팔꿈치", style: .middle) {
                        Toggle("팔꿈치", isOn: $patient.cautionElbow)
                            .labelsHidden()
                            .tintColorSet(theme.colorTheme.error)
                    }
                    .scrollDismissAnimation()
                    field(label: "엉덩뼈", style: .middle) {
                        Toggle("엉덩뼈", isOn: $patient.cautionHip)
                            .labelsHidden()
                            .tintColorSet(theme.colorTheme.error)
                    }
                    .scrollDismissAnimation()
                    field(label: "발꿈치", style: .bottom) {
                        Toggle("발꿈치", isOn: $patient.cautionHeel)
                            .labelsHidden()
                            .tintColorSet(theme.colorTheme.error)
                    }
                    .scrollDismissAnimation()
                }
                fieldSection {
                    field(label: "키", style: .top) {
                        HStack(spacing: 8) {
                            Text(String(format: "%.1f cm", patient.height ?? 0))
                                .textStyle(theme.textTheme.bodyLarge)
                                .foregroundColorSet(theme.colorTheme.onSurface)
                            Stepper(
                                "키",
                                value: Binding<Float>(get: { patient.height ?? 0 }, set: { patient.height = $0 }),
                                in: 0...250
                            )
                            .labelsHidden()
                        }
                    }
                    .scrollDismissAnimation()
                    field(label: "몸무게", style: .bottom) {
                        HStack(spacing: 8) {
                            Text(String(format: "%.1f kg", patient.weight ?? 0))
                                .textStyle(theme.textTheme.bodyLarge)
                                .foregroundColorSet(theme.colorTheme.onSurface)
                            Stepper(
                                "몸무게",
                                value: Binding<Float>(get: { patient.weight ?? 0 }, set: { patient.weight = $0 }),
                                in: 14...120
                            )
                            .labelsHidden()
                        }
                    }
                    .scrollDismissAnimation()
                }
            }
        }
        .contentMargins(.horizontal, 12, for: .scrollContent)
        .scrollIndicators(.never)
    }
    
    @ViewBuilder
    private func field<V: View>(
        label: LocalizedStringResource,
        axis: Axis = .horizontal,
        style: FieldStyle = .single,
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
        .frame(minHeight: 50)
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
    private func fieldSection<V: View>(@ViewBuilder content: ()->V) -> some View {
        VStack(spacing: 0) {
            Group(subviews: content()) { collection in
                if let first = collection.first {
                    first
                }
                ForEach(collection.dropFirst()) { subview in
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColorSet(theme.colorTheme.outline)
                    subview
                }
            }
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
    PatientInfo()
        .background(Color.black)
}
