//
//  PostureLogWidget.swift
//  BedSolution
//
//  Created by 이재호 on 11/3/25.
//

import SwiftUI

struct PostureLogWidget: View {
  @Environment(\.theme) private var theme
  @Environment(PatientStatusViewModel.self) private var vm
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
      PartPressureTimeRow(part: "뒤통수", time: pressureLog.occiputTime, threshold: vm.occiputThreshold)
      PartPressureTimeRow(part: "견갑골", time: pressureLog.scapulaTime, threshold: vm.scapulaThreshold)
      PartPressureTimeRow(part: "우측 팔꿈치", time: pressureLog.rightElbowTime, threshold: vm.rightElbowThreshold)
      PartPressureTimeRow(part: "좌측 팔꿈치", time: pressureLog.leftElbowTime, threshold: vm.leftElbowThreshold)
      PartPressureTimeRow(part: "엉덩이", time: pressureLog.hipTime, threshold: vm.hipThreshold)
      PartPressureTimeRow(part: "우측 발꿈치", time: pressureLog.rightHeelTime, threshold: vm.rightHeeelThreshold)
      PartPressureTimeRow(part: "좌측 발꿈치", time: pressureLog.leftHeelTime, threshold: vm.leftHeelThreshold)
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

fileprivate struct PartPressureTimeRow: View {
  @Environment(\.theme) private var theme
  var part: LocalizedStringResource
  /// 부위 유지 시간 (초단위)
  var time: Int
  /// 한계값 (분단위)
  var threshold: Int?
  /// 한계값 (초단위)
  private var thresholdM: Int {
    (threshold ?? 120)*60
  }
  private var percentage: CGFloat {
    CGFloat(time)/CGFloat(thresholdM)
  }
  private var color: ColorSet {
    switch percentage {
    case 0..<0.2:
      theme.colorTheme.onSurface
    case 0.2..<0.4:
      theme.colorTheme.secondary
    case 0.4..<0.7:
      theme.colorTheme.primary
    default:
      theme.colorTheme.error
    }
  }
  private var size: CGFloat {
    switch percentage {
    case 0..<0.2:
      70
    case 0.2..<0.4:
      74
    case 0.4..<0.7:
      78
    default:
      80
    }
  }
  private var isPressureWarning: Bool {
    percentage >= 0.7
  }
  
  var body: some View {
    HStack {
      if isPressureWarning {
        Image(systemName: "exclamationmark.triangle.fill")
          .font(.caption)
          .foregroundColorSet(theme.colorTheme.error)
      }
      Text(part)
        .textStyle(theme.textTheme.bodyLarge)
        .foregroundColorSet(theme.colorTheme.onSurface)
      Spacer()
      Text(TimeFormatter.formattedDuration(seconds: time))
        .textStyle(theme.textTheme.emphasizedBodyLarge)
        .foregroundColorSet(color)
    }
    .frame(height: 25)
    .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
    .backgroundColorSet(theme.colorTheme.surfaceContainerHigh, in: Rectangle())
  }
}

#Preview {
  PostureLogWidget(pressureLog: PressureLog())
    .environment(PatientStatusViewModel())
}
