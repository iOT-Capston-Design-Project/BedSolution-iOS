//
//  PatientStatusCard.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct PatientStatusCard: View {
    @Environment(\.theme) private var theme
    
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
        VStack(alignment: .center, spacing: 3) {
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text("NAME")
                        .textStyle(theme.textTheme.emphasizedTitleLarge)
                    Text("환자 상태")
                        .textStyle(theme.textTheme.titleLarge)
                }
                .foregroundColorSet(theme.colorTheme.onSurface)
                HStack(spacing: 5) {
                    Text("마지막 자세 변경 시간")
                    Text(Date.now, format: .dateTime.hour().minute())
                }
                .textStyle(theme.textTheme.emphasizedTitleSmall)
                .foregroundColorSet(theme.colorTheme.error)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            blueprint
                .padding(EdgeInsets(top: 25, leading: 0, bottom: 15, trailing: 0))
            
            HStack {
                Spacer()
                Text("마지막 업데이트 시간")
                Text(Date.now, format: .dateTime)
            }
            .textStyle(theme.textTheme.labelSmall)
            .foregroundColorSet(theme.colorTheme.onSurface)
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
    PatientStatusCard()
}
