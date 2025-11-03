//
//  CriticalThresholdWidget.swift
//  BedSolution
//
//  Created by 이재호 on 11/1/25.
//

import SwiftUI

struct CriticalThresholdWidget: View {
  @Environment(\.theme) private var theme
  @Environment(PatientInfoViewModel.self) private var vm
  @Binding var occiputTime: Int?
  @Binding var scapulaTime: Int?
  @Binding var rightElbowTime: Int?
  @Binding var leftElbowTime: Int?
  @Binding var hipTime: Int?
  @Binding var rightHeelTime: Int?
  @Binding var leftHeelTime: Int?
  
  private var thresholdDisplay: some View {
    ZStack {
      // 뒤통수
      ThresholdSpot(threshold: occiputTime)
        .offset(x: 0, y: -110)
      // 견갑골
      ThresholdSpot(threshold: scapulaTime)
        .offset(x: 25, y: -75)
      // 우측 팔꿈치
      ThresholdSpot(threshold: rightElbowTime)
        .offset(x: 37, y: -40)
      // 좌측 팔꿈치
      ThresholdSpot(threshold: leftElbowTime)
        .offset(x: -37, y: -40)
      // 엉덩뼈
      ThresholdSpot(threshold: hipTime)
      // 우측 발꿈치
      ThresholdSpot(threshold: rightHeelTime)
        .offset(x: 15, y: 115)
      // 좌측 발꿈치
      ThresholdSpot(threshold: leftHeelTime)
        .offset(x: -15, y: 115)
    }
    .frame(width: 130, height: 250)
    .clipShape(HumanBodyOutlineShape())
    .overlay {
      HumanBodyLineShape()
        .stroke(lineWidth: 1)
        .foregroundColorSet(theme.colorTheme.outline)
    }
  }
  
  var body: some View {
    VStack {
      Label("부위별 임계 시간", systemImage: "timer")
        .textStyle(theme.textTheme.labelLarge)
        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      HStack(alignment: .center) {
        if !vm.isEditing {
          thresholdDisplay
          Divider()
        }
        // Threshold
        VStack(spacing: 8) {
          ThresholdRow(part: "뒤통수", threshold: $occiputTime)
          ThresholdRow(part: "견갑골", threshold: $scapulaTime)
          ThresholdRow(part: "우측 팔꿈치", threshold: $rightElbowTime)
          ThresholdRow(part: "좌측 팔꿈치", threshold: $leftElbowTime)
          ThresholdRow(part: "엉덩뼈", threshold: $hipTime)
          ThresholdRow(part: "우측 발꿈치", threshold: $leftHeelTime)
          ThresholdRow(part: "좌측 발꿈치", threshold: $rightHeelTime)
        }
      }
      
      Text("기본 임계시간은 2시간이에요.\n필요에 따라 조정할 수 있어요.")
        .multilineTextAlignment(.center)
        .textStyle(theme.textTheme.labelLarge)
        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
    }
    .fixedSize(horizontal: false, vertical: true)
    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .stroke(lineWidth: 1)
        .foregroundColorSet(theme.colorTheme.outline)
    }
  }
}

fileprivate struct ThresholdSpot: View {
  @Environment(\.theme) private var theme
  var threshold: Int?
  private var thresholdColor: ColorSet {
    guard let threshold else { return theme.colorTheme.onSurfaceVarient }
    return switch threshold {
    case 0..<30:
      theme.colorTheme.error
    case 30..<60:
      theme.colorTheme.primary
    default:
      theme.colorTheme.secondary
    }
  }
  private var circleSize: CGFloat {
    guard let threshold else { return 15 }
    return switch threshold {
    case 0..<30:
      35
    case 30..<60:
      32
    default:
      30
    }
  }
  var body: some View {
    ZStack {
      Circle()
        .opacity(0.1)
      Circle()
        .opacity(0.2)
        .padding(5)
      Circle()
        .opacity(0.3)
        .padding(12)
    }
    .foregroundColorSet(thresholdColor)
    .frame(width: circleSize, height: circleSize)
  }
}

fileprivate struct ThresholdRow: View {
  @Environment(\.theme) private var theme
  @Environment(PatientInfoViewModel.self) private var vm
  var part: LocalizedStringResource
  @Binding var threshold: Int?
  private let availableTimes: [Int?] = [
    nil,
    10, 15, 20, 25, 30, 35, 40, 45,
    50, 55, 60, 65, 70, 75, 80, 85,
    90, 95, 100, 105, 110, 115, 120
  ]
  
  var body: some View {
    HStack {
      Text(part)
        .textStyle(theme.textTheme.bodyLarge)
        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
      Spacer(minLength: 2)
      if vm.isEditing {
        Picker("", selection: $threshold) {
          ForEach(availableTimes, id: \.self) { time in
            Text(TimeFormatter.formattedDuration(minutes: time ?? 120))
          }
        }
        .textStyle(theme.textTheme.labelLarge)
        .tintColorSet(theme.colorTheme.primary)
        .fixedSize()
        .labelsHidden()
      } else {
        Text(TimeFormatter.formattedDuration(minutes: threshold ?? 120))
          .textStyle(theme.textTheme.emphasizedBodyLarge)
          .tintColorSet(theme.colorTheme.secondary)
      }
    }
    .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5))
  }
}

#Preview {
  @Previewable @State var occiput: Int? = 120
  @Previewable @State var scapula: Int? = 90
  @Previewable @State var rightElbow: Int? = 45
  @Previewable @State var leftElbow: Int? = 45
  @Previewable @State var hip: Int? = 120
  @Previewable @State var rightHeel: Int? = 25
  @Previewable @State var leftHeel: Int? = 25

  CriticalThresholdWidget(
    occiputTime: $occiput,
    scapulaTime: $scapula,
    rightElbowTime: $rightElbow,
    leftElbowTime: $leftElbow,
    hipTime: $hip,
    rightHeelTime: $rightHeel,
    leftHeelTime: $leftHeel
  )
  .environment(PatientInfoViewModel())
}
