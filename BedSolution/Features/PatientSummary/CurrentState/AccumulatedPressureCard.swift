//
//  AccumulatedPressureCard.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct AccumulatedPressureCard: View {
    @Environment(\.theme) private var theme
    var pressureLog: PressureLog
    var occiputTime: Int? = nil
    var scapulaTime: Int? = nil
    var elbowTime: Int? = nil
    var hipTime: Int? = nil
    var heelTime: Int? = nil
    private let columns = Array(repeating: GridItem(), count: 2)
    var caption: LocalizedStringResource = "자세 변경 이후 누적된 압력 시간입니다."
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("누적 압력")
                .textStyle(theme.textTheme.emphasizedTitleMedium)
                .foregroundColorSet(theme.colorTheme.onSurface)
            LazyVGrid(columns: columns) {
                PressureInfo(region: "뒤통수", period: pressureLog.occiput, threshold: occiputTime)
                PressureInfo(region: "견갑골", period: pressureLog.scapula, threshold: scapulaTime)
                PressureInfo(region: "팔꿈치", period: pressureLog.elbow, threshold: elbowTime)
                PressureInfo(region: "엉덩뼈", period: pressureLog.hip, threshold: hipTime)
                PressureInfo(region: "발꿈치", period: pressureLog.heel, threshold: heelTime)
            }
            Text(caption)
                .textStyle(theme.textTheme.labelSmall)
                .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))
        .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 15))
    }
}

struct PressureInfo: View {
    @Environment(\.theme) private var theme
    var region: LocalizedStringResource
    var period: Int // s 단위
    var threshold: Int // min 단위
    
    private var progress: Double {
        // v: seconds since last posture change (period is already seconds)
        let v = max(0.0, Double(period))
        // t: threshold in seconds (input threshold is minutes)
        let tSec = max(0.0, Double(threshold) * 60.0)
        // M: maximum window set to 120 minutes (in seconds)
        let M = 120.0 * 60.0
        // Clamp v to [0, M]
        let vc = min(v, M)

        // Handle degenerate cases safely
        if tSec <= 0 {
            // No meaningful threshold: scale entire range 0..M directly to 0..1
            return min(1.0, vc / M)
        }
        if M <= tSec {
            // Avoid zero division in last segment: treat anything beyond t as 1.0 boundary
            let a = (2.0 / 3.0) * tSec
            if vc <= a {
                return a > 0 ? 0.4 * (vc / a) : 0.0
            } else {
                let denom = max(1e-9, tSec - a)
                return min(1.0, 0.4 + 0.2 * ((vc - a) / denom))
            }
        }

        // Regular piecewise linear mapping
        let a = (2.0 / 3.0) * tSec
        if vc <= a {
            return a > 0 ? 0.4 * (vc / a) : 0.0
        } else if vc <= tSec {
            let denom = max(1e-9, tSec - a) // == tSec/3
            return 0.4 + 0.2 * ((vc - a) / denom)
        } else {
            let denom = max(1e-9, M - tSec)
            return min(1.0, 0.6 + 0.4 * ((vc - tSec) / denom))
        }
    }
    private var color: ColorSet {
        switch progress {
        case ...0.4:
            theme.colorTheme.secondary
        case ...0.65:
            theme.colorTheme.tertiary
        default:
            theme.colorTheme.error
        }
    }
    
    init(region: LocalizedStringResource, period: Int, threshold: Int?) {
        self.region = region
        self.period = period
        self.threshold = threshold ?? 120
    }
    
    var body: some View {
        HStack {
            Text(region)
                .textStyle(theme.textTheme.emphasizedBodyLarge)
                .foregroundColorSet(theme.colorTheme.onSurface)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(TimeFormatter.formattedDuration(from: Int(period/60)))
                    .textStyle(theme.textTheme.labelLarge)
                    .foregroundColorSet(theme.colorTheme.onSurface)
                VerticalProgressbar(color: color, progress: progress)
                    .frame(height: 12)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        .frame(minHeight: 40)
        .backgroundColorSet(theme.colorTheme.surfaceContainerHigh, in: RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    AccumulatedPressureCard(pressureLog: PressureLog())
}
