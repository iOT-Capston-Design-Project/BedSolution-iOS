//
//  PatientTimeStatus.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//

import SwiftUI

struct PatientTimeStatus: View {
    private enum DamageStatus {
        case low
        case mid
        case high
        
        var localizedDescription: LocalizedStringResource {
            switch self {
            case .low:
                "하"
            case .mid:
                "중"
            case .high:
                "상"
            }
        }
    }
    
    @Environment(\.theme) private var theme
    @State private var selection: PressureLog?
    @State private var pressureLogs: [PressureLog] = []
    var dayLog: DayLog
    
    private var blueprint: some View {
        ZStack {
            Image(.humanBody)
                .resizable()
                .aspectRatio(contentMode: .fit)
            // 엉덩뼈
            ZStack {
                spot(status: .low)
                label(
                    text: "엉덩뼈 (압력정도: \(DamageStatus.low.localizedDescription)",
                    status: .low
                )
                .offset(y: 28)
            }
            // 뒤통수
            ZStack {
                spot(status: .high)
                label(
                    text: "뒤통수 (압력정도: \(DamageStatus.high.localizedDescription)",
                    status: .high
                )
                .offset(x: -45, y: -28)
            }
            .offset(y: -100)
            // 견갑골
            ZStack {
                spot(status: .mid)
                label(
                    text: "견갑골 (압력정도: \(DamageStatus.mid.localizedDescription)",
                    status: .mid
                )
                .offset(x: 80, y: -10)
            }
            .offset(x: 25, y: -75)
            // 팔꿈치
            ZStack {
                spot(status: .low)
                label(
                    text: "팔꿈치 (압력정도: \(DamageStatus.low.localizedDescription)",
                    status: .low
                )
                .offset(x: 80)
            }
            .offset(x: 40, y: -40)
            // 발꿈치
            ZStack {
                spot(status: .high)
                label(
                    text: "발꿈치 (압력정도: \(DamageStatus.high.localizedDescription)",
                    status: .high
                )
                .offset(x: 80, y: -10)
            }
            .offset(x: 18, y: 115)
        }
        .frame(height: 255)
    }
    
    var body: some View {
        VStack {
            Text("시간별 압력")
                .textStyle(theme.textTheme.emphasizedTitleMedium)
                .foregroundColorSet(theme.colorTheme.onSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
            blueprint
                .padding(EdgeInsets(top: 25, leading: 0, bottom: 15, trailing: 0))
            ScrollTimeSelection(selection: $selection, pressureLogs: pressureLogs)
        }
        .padding(EdgeInsets(top: 10, leading: 8, bottom: 8, trailing: 8))
        .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 15))
        .task {
            await loadPressureLog()
        }
    }
    
    private func loadPressureLog() async {
        pressureLogs = [
            PressureLog(
                id: 1,
                createdAt: Date(),
                occiput: 85,
                scapula: 60,
                elbow: 40,
                heel: 95,
                hip: 50,
                dayID: 101
            ),
            PressureLog(
                id: 2,
                createdAt: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!,
                occiput: 70,
                scapula: 55,
                elbow: 45,
                heel: 88,
                hip: 60,
                dayID: 101
            ),
            PressureLog(
                id: 3,
                createdAt: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!,
                occiput: 65,
                scapula: 50,
                elbow: 42,
                heel: 80,
                hip: 58,
                dayID: 102
            )
        ]
        selection = pressureLogs.first
    }
    
    @ViewBuilder
    private func spot(status: DamageStatus) -> some View {
        let outSize: CGFloat = switch status {
        case .low:
            20
        case .mid:
            25
        case .high:
            30
        }
        let inSize: CGFloat = switch status {
        case .low:
            14
        case .mid:
            17
        case .high:
            20
        }
        let foregroundColor = switch status {
        case .low:
            theme.colorTheme.tertiary
        case .mid:
            theme.colorTheme.secondary
        case .high:
            theme.colorTheme.error
        }
        
        Circle()
            .frame(width: outSize, height: outSize)
            .foregroundColorSet(foregroundColor)
            .opacity(0.3)
            .overlay {
                Circle()
                    .frame(width: inSize, height: inSize)
                    .foregroundColorSet(foregroundColor)
                    .opacity(0.8)
            }
    }
    
    @ViewBuilder
    private func label(text: LocalizedStringResource, status: DamageStatus) -> some View {
        let foregroundColor = switch status {
        case .low:
            theme.colorTheme.onTertiaryContainer
        case .mid:
            theme.colorTheme.onSecondaryContainer
        case .high:
            theme.colorTheme.onErrorContainer
        }
        let backgroundColor = switch status {
        case .low:
            theme.colorTheme.tertiaryContainer
        case .mid:
            theme.colorTheme.secondaryContainer
        case .high:
            theme.colorTheme.errorContainer
        }
        Text(text)
            .textStyle(theme.textTheme.emphasizedLabelLarge)
            .foregroundColorSet(foregroundColor)
            .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
            .backgroundColorSet(backgroundColor, in: Capsule())
    }
}

#Preview {
    PatientTimeStatus(dayLog: DayLog())
}
