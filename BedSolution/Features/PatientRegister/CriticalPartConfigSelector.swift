//
//  PatientPartConfig.swift
//  BedSolution
//
//  Created by 이재호 on 11/5/25.
//

import SwiftUI

struct CriticalPartConfigSelector: View {
  @Environment(\.theme) private var theme
  @Binding var occiputTime: Int?
  @Binding var scapulaTime: Int?
  @Binding var rightElbowTime: Int?
  @Binding var leftElbowTime: Int?
  @Binding var hipTime: Int?
  @Binding var rightHeelTime: Int?
  @Binding var leftHeelTime: Int?
  
  var body: some View {
    ZStack {
      // 후두부
      TouchablePartSpot(threshold: $occiputTime)
        .offset(x: 0, y: -210)
      // 견갑골
      TouchablePartSpot(threshold: $scapulaTime)
        .offset(x: 45, y: -140)
      // 우측 팔꿈치
      TouchablePartSpot(threshold: $rightElbowTime)
        .offset(x: 80, y: -70)
      // 좌측 팔꿈치
      TouchablePartSpot(threshold: $leftElbowTime)
        .offset(x: -80, y: -70)
      // 엉덩뼈
      TouchablePartSpot(threshold: $hipTime)
      // 우측 발꿈치
      TouchablePartSpot(threshold: $rightHeelTime)
        .offset(x: 30, y: 220)
      // 좌측 발꿈치
      TouchablePartSpot(threshold: $leftHeelTime)
        .offset(x: -30, y: 220)
    }
    .frame(width: 270, height: 500)
    .clipShape(HumanBodyOutlineShape())
    .overlay {
      ZStack {
        HumanBodyLineShape()
          .stroke(lineWidth: 2)
          .foregroundColorSet(theme.colorTheme.outline)
        // 후두부
        PartLabel(part: "뒤통수", isSelected: occiputTime != nil)
          .offset(x: 0, y: -250)
        // 견갑골
        PartLabel(part: "견갑골", isSelected: scapulaTime != nil)
          .offset(x: 77, y: -170)
        // 우측 팔꿈치
        PartLabel(part: "우측 팔꿈치", isSelected: rightElbowTime != nil)
          .offset(x: 120, y: -100)
        // 좌측 팔꿈치
        PartLabel(part: "좌측 팔꿈치", isSelected: leftElbowTime != nil)
          .offset(x: -120, y: -110)
        // 엉덩뼈
        PartLabel(part: "엉덩뼈", isSelected: hipTime != nil)
          .offset(x: 0, y: -35)
        // 우측 발꿈치
        PartLabel(part: "우측 발꿈치", isSelected: rightHeelTime != nil)
          .offset(x: 70, y: 240)
        // 좌측 발꿈치
        PartLabel(part: "좌측 발꿈치", isSelected: leftHeelTime != nil)
          .offset(x: -70, y: 240)
      }
    }
  }
}

fileprivate struct PartLabel: View {
  @Environment(\.theme) private var theme
  var part: LocalizedStringResource
  var isSelected: Bool
  
  var body: some View {
    HStack(spacing: 5) {
        Text(part)
    }
    .textStyle(theme.textTheme.emphasizedBodyLarge)
    .foregroundColorSet(isSelected ? theme.colorTheme.onErrorContainer: theme.colorTheme.onSurfaceVarient)
    .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
    .backgroundColorSet(isSelected ? theme.colorTheme.errorContainer: theme.colorTheme.surfaceContainerHigh, in: Capsule())
  }
}

fileprivate struct TouchablePartSpot: View {
  @Environment(\.theme) private var theme
  @Binding var threshold: Int?
  private var size: CGFloat {
    threshold == nil ? 60: 80
  }
  private var color: ColorSet {
    threshold == nil ? theme.colorTheme.outline: theme.colorTheme.error
  }
  
  var body: some View {
    ZStack {
      Circle()
        .opacity(0.3)
        .frame(width: size, height: size)
      Circle()
        .opacity(0.2)
        .frame(width: size-20, height: size-20)
      Circle()
        .opacity(0.1)
        .frame(width: size-45, height: size-45)
    }
    .foregroundColorSet(color)
    .animation(.default, value: size)
    .onTapGesture {
      threshold = threshold == nil ? 60: nil
    }
  }
}

#Preview {
  @Previewable @State var occiputTime: Int?
  @Previewable @State var scapulaTime: Int?
  @Previewable @State var rightElbowTime: Int?
  @Previewable @State var leftElbowTime: Int?
  @Previewable @State var hipTime: Int?
  @Previewable @State var rightHeelTime: Int?
  @Previewable @State var leftHeelTime: Int?
  CriticalPartConfigSelector(
    occiputTime: $occiputTime,
    scapulaTime: $scapulaTime,
    rightElbowTime: $rightElbowTime,
    leftElbowTime: $leftElbowTime,
    hipTime: $hipTime,
    rightHeelTime: $rightHeelTime,
    leftHeelTime: $leftHeelTime
  )
}
