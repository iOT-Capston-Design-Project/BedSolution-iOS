//
//  PressureLogWidget.swift
//  BedSolution
//
//  Created by 이재호 on 11/4/25.
//

import SwiftUI

struct PressureLogWidget: View {
  @Environment(\.theme) private var theme
  var pressureLog: PressureLog
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Text(pressureLog.createdAt, format: .dateTime.hour().minute().second())
          .textStyle(theme.textTheme.emphasizedTitleMedium)
          .foregroundColorSet(theme.colorTheme.onSurface)
        Spacer()
        Text(pressureLog.postureType.title)
          .textStyle(theme.textTheme.emphasizedBodyLarge)
          .foregroundColorSet(theme.colorTheme.onSurface)
      }
      .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
      Divider()
        .foregroundColorSet(theme.colorTheme.outline)
      PartPressureTimeRow(part: "뒤통수", time: pressureLog.occiputTime)
      PartPressureTimeRow(part: "견갑골", time: pressureLog.scapulaTime)
      PartPressureTimeRow(part: "우측 팔꿈치", time: pressureLog.rightElbowTime)
      PartPressureTimeRow(part: "좌측 팔꿈치", time: pressureLog.leftElbowTime)
      PartPressureTimeRow(part: "엉덩이", time: pressureLog.hipTime)
      PartPressureTimeRow(part: "우측 발꿈치", time: pressureLog.rightHeelTime)
      PartPressureTimeRow(part: "좌측 발꿈치", time: pressureLog.leftHeelTime)
    }
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .stroke(lineWidth: 1)
        .foregroundColorSet(theme.colorTheme.outline)
    }
  }
}

#Preview {
  PressureLogWidget(pressureLog: PressureLog())
}

fileprivate struct PartPressureTimeRow: View {
  @Environment(\.theme) private var theme
  var part: LocalizedStringResource
  /// 부위 유지 시간 (초단위)
  var time: Int
  
  var body: some View {
    HStack {
      Text(part)
        .textStyle(theme.textTheme.bodyLarge)
        .foregroundColorSet(theme.colorTheme.onSurface)
      Spacer()
      Text(TimeFormatter.formattedDuration(seconds: time))
        .textStyle(theme.textTheme.emphasizedBodyLarge)
        .foregroundColorSet(theme.colorTheme.onSurface)
    }
    .frame(height: 25)
    .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
    .backgroundColorSet(theme.colorTheme.surfaceContainerHigh, in: Rectangle())
  }
}
