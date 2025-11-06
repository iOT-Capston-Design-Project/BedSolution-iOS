//
//  PatientBodyPressureWidget.swift
//  BedSolution
//
//  Created by 이재호 on 11/3/25.
//

import SwiftUI

struct PatientBodyPressureWidget: View {
  @Environment(\.theme) private var theme
  @Environment(PatientStatusViewModel.self) private var vm
  
  private var pressureView: some View {
    ZStack {
      // 후두부
      PressureSpot(time: vm.occiputTime, threshold: vm.occiputThreshold)
        .offset(x: 0, y: -240)
      // 견갑골
      PressureSpot(time: vm.scapulaTime, threshold: vm.scapulaThreshold)
        .offset(x: 40, y: -150)
      // 엉덩뼈
      PressureSpot(time: vm.hipTime, threshold: vm.hipThreshold)
      // 우측 팔꿈치
      PressureSpot(time: vm.rightElbowTime, threshold: vm.rightElbowThreshold)
        .offset(x: 90, y: -80)
      // 좌측 팔꿈치
      PressureSpot(time: vm.leftElbowTime, threshold: vm.leftElbowThreshold)
        .offset(x: -90, y: -80)
      // 우측 발꿈치
      PressureSpot(time: vm.rightHeeelTime, threshold: vm.rightHeeelThreshold)
        .offset(x: 40, y: 270)
      // 좌측 발꿈치
      PressureSpot(time: vm.leftHeelTime, threshold: vm.leftHeelThreshold)
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
        PressureLabel(part: "뒤통수", time: vm.occiputTime, threshold: vm.occiputThreshold)
          .offset(x: 80, y: -270)
        // 견갑골
        PressureLabel(part: "견갑골", time: vm.scapulaTime, threshold: vm.scapulaThreshold)
          .offset(x: 100, y: -170)
        // 엉덩뼈
        PressureLabel(part: "엉덩뼈", time: vm.hipTime, threshold: vm.hipThreshold)
          .offset(x: 0, y: 48)
        // 우측 팔꿈치
        PressureLabel(part: "우측 팔꿈치", time: vm.rightElbowTime, threshold: vm.rightElbowThreshold)
          .offset(x: 100, y: -40)
        // 좌측 팔꿈치
        PressureLabel(part: "좌측 팔꿈치", time: vm.leftElbowTime, threshold: vm.leftElbowThreshold)
          .offset(x: -100, y: -140)
        // 우측 발꿈치
        PressureLabel(part: "우측 발꿈치", time: vm.rightHeeelTime, threshold: vm.rightHeeelThreshold)
          .offset(x: 100, y: 220)
        // 좌측 발꿈치
        PressureLabel(part: "좌측 발꿈치", time: vm.leftHeelTime, threshold: vm.leftHeelThreshold)
          .offset(x: -100, y: 210)
      }
    }
  }
  
  var body: some View {
    VStack {
      HStack {
        Label("부위별 압력", systemImage: "timer")
          .textStyle(theme.textTheme.labelLarge)
          .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        Spacer()
        Text(vm.posture.title)
          .textStyle(theme.textTheme.emphasizedBodyLarge)
          .foregroundColorSet(theme.colorTheme.primary)
      }
      pressureView
        .padding(EdgeInsets(top: 24, leading: 0, bottom: 8, trailing: 0))
    }
    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 8))
    .overlay {
      if let vmError = vm.error {
        ZStack {
          RoundedRectangle(cornerRadius: 8)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 8))
          VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle.fill")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 35, height: 35)
            Text(errorMessage(vmError))
              .textStyle(theme.textTheme.emphasizedLabelLarge)
          }
          .foregroundColorSet(theme.colorTheme.error)
        }
        .transition(.opacity)
      } else if vm.dayLog == nil {
        ZStack {
          RoundedRectangle(cornerRadius: 8)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 8))
          VStack(spacing: 5) {
            Text("오늘 기록된 압력정보가 없어요.")
              .textStyle(theme.textTheme.emphasizedTitleMedium)
              .foregroundColorSet(theme.colorTheme.onSurface)
            Text("장치에서 압력이 수집 중일 수도 있어요.\n잠시만 기다려 주세요.")
              .multilineTextAlignment(.center)
              .textStyle(theme.textTheme.labelLarge)
              .foregroundColorSet(theme.colorTheme.onSurface)
          }
        }
        .transition(.opacity)
      }
    }
    .animation(.default, value: vm.error)
    .animation(.default, value: vm.dayLog)
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .stroke(lineWidth: 1)
        .foregroundColorSet(theme.colorTheme.outline)
    }
  }
  
  private func errorMessage(_ error: PatientStatusVMError) -> LocalizedStringResource {
    switch error {
    case .internalError:
      "내부 오류가 발생했어요."
    case .fetchPatientFailed:
      "환자 정보를 불러올 수 없어요."
    case .noPatient:
      "등록된 환자가 없어요."
    case .fetchPressureLogFailed:
      "압력 기록을 불러올 수 없어요."
    case .noDayLog:
      "오늘 기록된 압력정보가 없어요."
    case .noDeviceID:
      "장치 등록이 필요해요."
    case .fetchDayLogFailed:
      "오늘 기록 정보를 불러올 수 없어요."
    }
  }
}

fileprivate struct PressureSpot: View {
  @Environment(\.theme) private var theme
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
      theme.colorTheme.outline
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
    .frame(width: size, height: size)
    .foregroundColorSet(color)
  }
}

fileprivate struct PressureLabel: View {
  @Environment(\.theme) private var theme
  /// 부위
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
      theme.colorTheme.onSurfaceVarient
    case 0.2..<0.4:
      theme.colorTheme.secondary
    case 0.4..<0.7:
      theme.colorTheme.primary
    default:
      theme.colorTheme.error
    }
  }
  private var isPressureWarning: Bool {
    percentage >= 0.7
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      HStack {
        HStack(spacing: 3) {
          if isPressureWarning {
            Image(systemName: "exclamationmark.triangle.fill")
              .font(.caption)
              .foregroundColorSet(theme.colorTheme.error)
          }
          Text(part)
            .textStyle(theme.textTheme.emphasizedTitleMedium)
            .foregroundColorSet(theme.colorTheme.onSurface)
        }
        Spacer(minLength: 5)
        VerticalProgressbar(color: color, progress: percentage)
            .frame(height: 12)
      }
      Text(TimeFormatter.formattedDuration(seconds: time))
        .textStyle(theme.textTheme.emphasizedTitleMedium)
        .foregroundColorSet(color)
    }
    .frame(width: 125)
    .padding(EdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12))
    .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 8))
    .overlay {
      if isPressureWarning {
        RoundedRectangle(cornerRadius: 8)
          .stroke(lineWidth: 2)
          .foregroundColorSet(theme.colorTheme.error)
      }
    }
  }
}

#Preview {
    PatientBodyPressureWidget()
      .environment(PatientStatusViewModel())
}
