//
//  PostureChangeWidget.swift
//  BedSolution
//
//  Created by 이재호 on 11/6/25.
//

import SwiftUI

struct PostureChangeWidget: View {
  @Environment(\.theme) private var theme
  @Environment(PatientStatusViewModel.self) private var vm
  
  var body: some View {
    VStack(alignment: .leading) {
      Label("압력 경고", systemImage: "exclamationmark.triangle.fill")
        .textStyle(theme.textTheme.labelLarge)
        .foregroundColorSet(theme.colorTheme.error)
        .frame(maxWidth: .infinity, alignment: .leading)
      Text(warnMessage())
        .textStyle(theme.textTheme.bodyLarge)
        .foregroundColorSet(theme.colorTheme.onSurface)
        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
    }
    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 8))
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .stroke(lineWidth: 1)
        .foregroundColorSet(theme.colorTheme.outline)
    }
  }
  
  private func requiredParts() -> [LocalizedStringResource] {
    var parts: [LocalizedStringResource] = []
    
    func thresholdTimeConverter(_ time: Int?) -> Int {
      guard let time else { return 120*60 }
      return time*60
    }
    
    if vm.occiputTime >= thresholdTimeConverter(vm.occiputThreshold) {
      parts.append("뒤통수")
    }
    if vm.scapulaTime >= thresholdTimeConverter(vm.scapulaThreshold) {
      parts.append("견갑골")
    }
    if vm.rightElbowTime >= thresholdTimeConverter(vm.rightElbowThreshold) {
      parts.append("우측 팔꿈치")
    }
    if vm.leftElbowTime >= thresholdTimeConverter(vm.leftElbowThreshold) {
      parts.append("좌측 팔꿈치")
    }
    if vm.hipTime >= thresholdTimeConverter(vm.hipThreshold) {
      parts.append("엉덩뼈")
    }
    if vm.rightHeeelTime >= thresholdTimeConverter(vm.rightHeeelThreshold) {
      parts.append("우측 발꿈치")
    }
    if vm.leftHeelTime >= thresholdTimeConverter(vm.leftHeelThreshold) {
      parts.append("좌측 발꿈치")
    }
    return parts
  }
  
  private func warnMessage() -> String {
    let parts = requiredParts()
    var message: String = String(localized: "다음 부위에 지속적입 압력이 가해졌습니다.\n자세 변경을 권장합니다.")
    
    if !parts.isEmpty {
      let partNames = parts.map { String(localized: $0) }
      message += String(localized: "\n부위: ")
      message += partNames.joined(separator: ", ")
    }
    
    return message
  }
}

#Preview {
  PostureChangeWidget()
    .environment(PatientStatusViewModel())
}
