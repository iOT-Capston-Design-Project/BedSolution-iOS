//
//  DayLogDetailView.swift
//  BedSolution
//
//  Created by 이재호 on 11/4/25.
//

import SwiftUI

struct DayLogDetailView: View {
  @Environment(\.theme) private var theme
  @Environment(\.dismiss) private var dismiss
  @State private var vm = DayLogDetailViewModel()
  @State private var errorAlert: Bool = false
  var dayLog: DayLog
  
  var body: some View {
    ScrollView {
      LazyVStack {
        PressurePartsSummaryWidget()
        if !vm.pressureLogs.isEmpty {
          Section {
            ForEach(vm.pressureLogs) { pressureLog in
              PressureLogWidget(pressureLog: pressureLog)
            }
          } header: {
            Text("자세 변경 기록")
              .textStyle(theme.textTheme.emphasizedTitleMedium)
              .foregroundColorSet(theme.colorTheme.onSurface)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(EdgeInsets(top: 8, leading: 0, bottom: 3, trailing: 0))
          }
        }
      }
      .scrollTargetLayout()
    }
    .scrollTargetBehavior(.viewAligned)
    .scrollIndicators(.never)
    .contentMargins(.horizontal, 10)
    .contentMargins(.vertical, 6)
    .navigationTitle(Text(vm.day, format: .dateTime.year().month().day()))
    .navigationBarTitleDisplayMode(.inline)
    .environment(vm)
    .alert(
      isPresented: $errorAlert,
      error: vm.error,
      actions: { _ in
        Button(action: { dismiss() }) {
          Text("확인")
        }
      },
      message: { error in
        Text(errorMessage(error: error))
      }
    )
    .onChange(of: vm.error) { _, error in
        errorAlert = error != nil
    }
    .task {
      await vm.fetch(daylog: dayLog)
    }
  }
  
  private func errorMessage(error: Error) -> LocalizedStringResource {
    guard let error = error as? DayLogDetailVMError else { return "알 수 없는 오류가 발생했어요." }
    switch error {
    case .fetchPressureLogFailed:
      return "압력 기록을 불러올 수 없어요."
    case .noDayLog:
      return "해당 날짜 기록이 없어요."
    }
  }
}

#Preview {
  NavigationStack {
    DayLogDetailView(dayLog: DayLog())
  }
}
