//
//  PatientStatusCard.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct PatientStatusCard: View {
    @Environment(\.theme) private var theme
    var name: String
    var occiputTime: Int? = nil
    var scapulaTime: Int? = nil
    var elbowTime: Int? = nil
    var hipTime: Int? = nil
    var heelTime: Int? = nil
    var pressureLog: PressureLog
    
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
        
        static func getStatus(pressure: Int, threshold: Int?) -> DamageStatus {
            let threshold = (threshold ?? 120)*60
            switch pressure {
            case 0..<threshold:
                return .mid
            case threshold...:
                return .high
            default:
                return .low
            }
        }
    }
    
    private var blueprint: some View {
        ZStack {
            Image(.humanBody)
                .resizable()
                .aspectRatio(contentMode: .fit)
            // 엉덩뼈
            ZStack {
                spot(status: DamageStatus.getStatus(pressure: pressureLog.hip, threshold: hipTime))
                label(
                    text: "엉덩뼈 (압력정도: \(DamageStatus.getStatus(pressure: pressureLog.hip, threshold: hipTime).localizedDescription)",
                    status: DamageStatus.getStatus(pressure: pressureLog.hip, threshold: hipTime)
                )
                .offset(y: 28)
            }
            // 뒤통수
            ZStack {
                spot(status: DamageStatus.getStatus(pressure: pressureLog.occiput, threshold: occiputTime))
                label(
                    text: "뒤통수 (압력정도: \(DamageStatus.getStatus(pressure: pressureLog.occiput, threshold: occiputTime).localizedDescription)",
                    status: DamageStatus.getStatus(pressure: pressureLog.occiput, threshold: occiputTime)
                )
                .offset(x: -45, y: -28)
            }
            .offset(y: -100)
            // 견갑골
            ZStack {
                spot(status: DamageStatus.getStatus(pressure: pressureLog.scapula, threshold: scapulaTime))
                label(
                    text: "견갑골 (압력정도: \(DamageStatus.getStatus(pressure: pressureLog.scapula, threshold: scapulaTime).localizedDescription)",
                    status: DamageStatus.getStatus(pressure: pressureLog.scapula, threshold: scapulaTime)
                )
                .offset(x: 80, y: -10)
            }
            .offset(x: 25, y: -75)
            // 팔꿈치
            ZStack {
                spot(status: DamageStatus.getStatus(pressure: pressureLog.elbow, threshold: elbowTime))
                label(
                    text: "팔꿈치 (압력정도: \(DamageStatus.getStatus(pressure: pressureLog.elbow, threshold: elbowTime).localizedDescription)",
                    status: DamageStatus.getStatus(pressure: pressureLog.elbow, threshold: elbowTime)
                )
                .offset(x: 80)
            }
            .offset(x: 40, y: -40)
            // 발꿈치
            ZStack {
                spot(status: DamageStatus.getStatus(pressure: pressureLog.heel, threshold: heelTime))
                label(
                    text: "발꿈치 (압력정도: \(DamageStatus.getStatus(pressure: pressureLog.heel, threshold: heelTime).localizedDescription)",
                    status: DamageStatus.getStatus(pressure: pressureLog.heel, threshold: heelTime)
                )
                .offset(x: 80, y: -10)
            }
            .offset(x: 18, y: 115)
        }
        .frame(height: 255)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(name)
                        .textStyle(theme.textTheme.emphasizedTitleLarge)
                    Text("환자 상태")
                        .textStyle(theme.textTheme.titleLarge)
                }
                .foregroundColorSet(theme.colorTheme.onSurface)
                HStack(spacing: 5) {
                    Text("마지막 자세 변경 시간")
                    Text(pressureLog.createdAt, format: .dateTime.hour().minute())
                }
                .textStyle(theme.textTheme.emphasizedTitleSmall)
                .foregroundColorSet(theme.colorTheme.error)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            blueprint
                .padding(EdgeInsets(top: 25, leading: 0, bottom: 15, trailing: 0))
        }
        .padding(EdgeInsets(top: 10, leading: 8, bottom: 8, trailing: 8))
        .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 15))
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
    PatientStatusCard(name: "Lee Jaeho", pressureLog: PressureLog())
}
