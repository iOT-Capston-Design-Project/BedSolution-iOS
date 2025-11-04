//
//  PressurePartsSummaryWidget.swift
//  BedSolution
//
//  Created by 이재호 on 11/4/25.
//

import SwiftUI

struct PressurePartsSummaryWidget: View {
  @Environment(\.theme) private var theme
  @Environment(DayLogDetailViewModel.self) private var vm
  
  private var pressureView: some View {
    ZStack {
      // 후두부
      PressureSpot()
        .offset(x: 0, y: -240)
      // 견갑골
      PressureSpot()
        .offset(x: 40, y: -150)
      // 엉덩뼈
      PressureSpot()
      // 우측 팔꿈치
      PressureSpot()
        .offset(x: 90, y: -80)
      // 좌측 팔꿈치
      PressureSpot()
        .offset(x: -90, y: -80)
      // 우측 발꿈치
      PressureSpot()
        .offset(x: 40, y: 270)
      // 좌측 발꿈치
      PressureSpot()
        .offset(x: -40, y: 270)
    }
    .frame(width: 280, height: 550)
    .clipShape(HumanBodyOutlineShape())
    .overlay {
      ZStack {
        HumanBodyLineShape()
          .stroke(lineWidth: 1)
          .foregroundColorSet(theme.colorTheme.outline)
        // 후두부
        PressureLabel(part: "뒤통수", time: vm.occiputTime)
          .offset(x: 80, y: -270)
        // 견갑골
        PressureLabel(part: "견갑골", time: vm.scapulaTime)
          .offset(x: 100, y: -170)
        // 엉덩뼈
        PressureLabel(part: "엉덩뼈", time: vm.hipTime)
          .offset(x: 0, y: 48)
        // 우측 팔꿈치
        PressureLabel(part: "우측 팔꿈치", time: vm.rightElbowTime)
          .offset(x: 100, y: -40)
        // 좌측 팔꿈치
        PressureLabel(part: "좌측 팔꿈치", time: vm.leftHeelTime)
          .offset(x: -100, y: -140)
        // 우측 발꿈치
        PressureLabel(part: "우측 발꿈치", time: vm.rightHeeelTime)
          .offset(x: 100, y: 220)
        // 좌측 발꿈치
        PressureLabel(part: "좌측 발꿈치", time: vm.leftHeelTime)
          .offset(x: -100, y: 210)
      }
    }
  }
  
  var body: some View {
    VStack {
      Label("총 누적 압력", systemImage: "timer")
        .textStyle(theme.textTheme.labelLarge)
        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        .frame(maxWidth: .infinity, alignment: .leading)
      pressureView
    }
    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .stroke(lineWidth: 1)
        .foregroundColorSet(theme.colorTheme.outline)
    }
  }
}

fileprivate struct PressureSpot: View {
  @Environment(\.theme) private var theme
  
  var body: some View {
    ZStack {
      Circle()
        .opacity(0.2)
      Circle()
        .opacity(0.2)
        .padding(10)
      Circle()
        .opacity(0.2)
        .padding(20)
    }
    .frame(width: 80, height: 80)
    .foregroundColorSet(theme.colorTheme.outline)
  }
}

fileprivate struct PressureLabel: View {
  @Environment(\.theme) private var theme
  /// 부위
  var part: LocalizedStringResource
  /// 부위 유지 시간 (초단위)
  var time: Int
  
  var body: some View {
    HStack {
      Text(part)
        .textStyle(theme.textTheme.emphasizedTitleMedium)
        .foregroundColorSet(theme.colorTheme.onSurface)
      Spacer(minLength: 5)
      Text(TimeFormatter.formattedDuration(seconds: time))
        .textStyle(theme.textTheme.emphasizedTitleMedium)
        .foregroundColorSet(theme.colorTheme.onSurface)
    }
    .frame(width: 125)
    .padding(EdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12))
    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 8))
  }
}


#Preview {
    PressurePartsSummaryWidget()
    .environment(DayLogDetailViewModel())
}
