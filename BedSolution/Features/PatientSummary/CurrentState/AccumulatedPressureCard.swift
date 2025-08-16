//
//  AccumulatedPressureCard.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct AccumulatedPressureCard: View {
    @Environment(\.theme) private var theme
    private let columns = Array(repeating: GridItem(), count: 2)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("누적 압력")
                .textStyle(theme.textTheme.emphasizedTitleMedium)
                .foregroundColorSet(theme.colorTheme.onSurface)
            LazyVGrid(columns: columns) {
                PressureInfo(region: "뒤통수", period: 60*60+60*40)
                PressureInfo(region: "견갑골", period: 60*60+60*10)
                PressureInfo(region: "팔꿈치", period: 60*30)
                PressureInfo(region: "엉덩뼈", period: 60*60+60*40)
                PressureInfo(region: "발꿈치", period: 60*60)
            }
            Text("자세 변경 이후 누적된 압력 시간입니다.")
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
    var period: TimeInterval
    var max: TimeInterval
    
    private var formatter: DateComponentsFormatter {
        let f = DateComponentsFormatter()
        if period >= 3600 {
            f.allowedUnits = [.hour, .minute]
        } else {
            f.allowedUnits = [.minute]
        }
        f.unitsStyle = .brief
        f.zeroFormattingBehavior = [.pad]
        return f
    }
    
    private var progress: Double {
        Swift.min(period/max, max)
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
    
    init(region: LocalizedStringResource, period: TimeInterval, max: TimeInterval = 60*60*2) {
        self.region = region
        self.period = period
        self.max = max
    }
    
    var body: some View {
        HStack {
            Text(region)
                .textStyle(theme.textTheme.emphasizedBodyLarge)
                .foregroundColorSet(theme.colorTheme.onSurface)
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(formatter.string(from: period) ?? "NONE")
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
    AccumulatedPressureCard()
}
