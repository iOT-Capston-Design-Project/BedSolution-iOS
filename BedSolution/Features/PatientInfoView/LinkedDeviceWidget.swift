//
//  LinkedDeviceWidget.swift
//  BedSolution
//
//  Created by 이재호 on 11/1/25.
//

import SwiftUI

struct LinkedDeviceWidget: View {
  @Environment(\.theme) private var theme
  @Environment(PatientInfoViewModel.self) private var vm
  @Binding var deviceID: Int?
  
  var body: some View {
    VStack {
      Label("연결된 장치", systemImage: "bed.double.fill")
        .textStyle(theme.textTheme.labelLarge)
        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      if vm.isEditing {
        // 장치 연결 필드
        HStack {
          Text("장치 ID")
            .textStyle(theme.textTheme.bodyLarge)
            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
          
          TextField(
            "장치 ID",
            text: Binding<String>(
              get: {
                if let deviceID {
                  return String(deviceID)
                } else {
                  return ""
                }
              },
              set: {
                if let intValue = Int($0) {
                  deviceID = intValue
                } else {
                  deviceID = nil
                }
              }
            ),
            prompt: Text("장치 ID")
          )
          .multilineTextAlignment(.trailing)
          .textStyle(theme.textTheme.emphasizedBodyLarge)
          .foregroundColorSet(theme.colorTheme.onSurface)
        }
        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
      } else if let deviceID {
        // 장치 연결시
        HStack {
          Text("장치 ID")
            .textStyle(theme.textTheme.bodyLarge)
            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
          
          Spacer()
          Text(String(deviceID))
            .textStyle(theme.textTheme.emphasizedBodyLarge)
            .foregroundColorSet(theme.colorTheme.onSurface)
        }
        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
      } else {
        VStack(spacing: 3) {
          Text("환자와 연결된 장치가 없어요")
            .textStyle(theme.textTheme.emphasizedBodyLarge)
            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
          Text("장치 소프트웨어의 설정/디바이스에서\n장치 ID를 확인할 수 있어요.")
            .multilineTextAlignment(.center)
            .textStyle(theme.textTheme.bodyMedium)
            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        }
        .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
      }
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

#Preview {
  @Previewable @State var deviceID: Int?
  LinkedDeviceWidget(deviceID: $deviceID)
    .environment(PatientInfoViewModel())
}
