//
//  PatientInfoWidget.swift
//  BedSolution
//
//  Created by 이재호 on 11/1/25.
//

import SwiftUI

struct PatientInfoWidget: View {
  @Environment(\.theme) private var theme
  @Environment(PatientInfoViewModel.self) private var vm
  @State private var showWeightPicker = false
  @Binding var name: String
  @Binding var weight: Float?
  
  var body: some View {
    VStack {
      Label("환자 정보", systemImage: "person.fill")
        .textStyle(theme.textTheme.labelLarge)
        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      // 몸무게
      HStack {
        Text("이름")
          .textStyle(theme.textTheme.bodyLarge)
          .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        Spacer()
        Group {
          if vm.isEditing {
            TextField("환자 이름", text: $name, prompt: Text("환자 이름"))
              .multilineTextAlignment(.trailing)
              .labelsHidden()
              .foregroundColorSet(theme.colorTheme.primary)
          } else {
            Text(name)
              .foregroundColorSet(theme.colorTheme.onSurface)
          }
        }
        .textStyle(theme.textTheme.emphasizedBodyLarge)
      }
      .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5))
      
      // 몸무게
      HStack {
        Text("몸무게")
          .textStyle(theme.textTheme.bodyLarge)
          .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
        Spacer()
        Button(action: { showWeightPicker.toggle() }) {
          Text("\(String(weight ?? 0)) kg")
            .textStyle(theme.textTheme.emphasizedBodyLarge)
            .foregroundColorSet(vm.isEditing ? theme.colorTheme.primary: theme.colorTheme.onSurface)
        }
        .disabled(!vm.isEditing)
        .popover(isPresented: $showWeightPicker) {
          WeightPickerPopup(weight: $weight)
            .presentationDetents([.fraction(0.4)])
            .interactiveDismissDisabled()
        }
      }
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
}

fileprivate struct WeightPickerPopup: View {
  @Environment(\.theme) private var theme
  @Environment(\.dismiss) private var dismiss
  @Binding var weight: Float?
  @State private var displayedWeight: Float = 0
  @State private var debounceWorkItem: DispatchWorkItem?
  
  var body: some View {
    VStack(spacing: 20) {
      Spacer()
      VStack {
        Text("환자명의 몸무게를 입력해주세요")
            .textStyle(theme.textTheme.emphasizedTitleSmall)
        Text("\(String(displayedWeight)) kg")
            .textStyle(theme.textTheme.emphasizedDisplaySmall)
            .contentTransition(.numericText(value: Double(displayedWeight)))
      }
      WeightPicker(weight: Binding<Int>(get: { Int(weight ?? 0) }, set: { weight = Float($0) }))
      Spacer()
      Button(action: { dismiss() }) {
        Text("완료")
      }
      .buttonStyle(
        type: .emphasized,
        option: .fiilled,
        primary: theme.colorTheme.primary,
        onPrimary: theme.colorTheme.onPrimary
      )
    }
    .onAppear {
      displayedWeight = weight ?? 0
    }
    .onChange(of: weight ?? 0) { _, newWeight in
        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            withAnimation(.default) { self.displayedWeight = newWeight }
        }
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: workItem)
    }
  }
}

#Preview {
  NavigationStack {
    PatientInfoView(
      patient: Patient(
        id: 2625083234860015468, createdAt: .now,
        uid: UUID(uuidString: "d9542f41-2177-4522-a833-b48afeff8b19")!,
        name: "",
        occiputTime: nil, scapulaTime: nil, elbowTime: nil, hipTime: nil, heelTime: nil
      )
    )
  }
}
