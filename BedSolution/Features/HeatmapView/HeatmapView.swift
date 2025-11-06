//
//  HeatmapView.swift
//  BedSolution
//
//  Created by 이재호 on 11/4/25.
//

import SwiftUI

struct HeatmapView: View {
  @Environment(\.theme) private var theme
  @State private var vm = HeatmapViewModel()
  
  var patient: Patient
  
  private var heatmapGrid: some View {
    GeometryReader { proxy in
      Canvas { context, size in
        let values = vm.heatmap
        guard !values.isEmpty else { return }
        let rows = values.count
        let columns = values.first?.count ?? 0
        guard columns > 0 else { return }
        let flattened = values.flatMap { $0 }
        let minValue = flattened.min() ?? 0
        let maxValue = flattened.max() ?? 0
        let cellSize = CGSize(
          width: size.width/CGFloat(columns),
          height: size.height/CGFloat(rows)
        )
        
        for rowIdx in 0..<rows {
          for columnIdx in 0..<columns {
            let origin = CGPoint(
              x: CGFloat(columnIdx)*cellSize.width,
              y: CGFloat(rowIdx)*cellSize.height
            )
            let rect = Rectangle()
              .path(in: CGRect(origin: origin, size: cellSize))
            context.fill(
              rect,
              with: .color(
                pressureColor(for: values[rowIdx][columnIdx], min: minValue, max: maxValue)
              )
            )
          }
        }
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
  
  var body: some View {
    NavigationStack {
      heatmapGrid
        .overlay {
          if let vmError = vm.error {
            VStack(spacing: 5) {
              Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColorSet(theme.colorTheme.error)
              Text(errorTitle(vmError))
                .textStyle(theme.textTheme.emphasizedTitleMedium)
                .foregroundColorSet(theme.colorTheme.error)
            }
          }
        }
        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
        .backgroundColorSet(theme.colorTheme.surface)
        .navigationTitle(Text("압력 히트맵"))
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
          Group {
            if let latestUpdate = vm.latestUpdate, vm.isStreaming {
              Text(latestUpdate, format: .dateTime.hour().minute().second())
                .contentTransition(.numericText())
            } else {
              Text("히트맵이 중지되었어요.")
            }
          }
          .textStyle(theme.textTheme.emphasizedLabelLarge)
          .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
          .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
          .frame(minHeight: 35)
          .glassEffect(.regular, in: Capsule())
          .animation(.default, value: vm.latestUpdate)
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
        }
        .toolbar {
          ToolbarItem(placement: .primaryAction) {
            Button(action: toggleStreaming) {
              Label(vm.isStreaming ? "정지": "시작", systemImage: vm.isStreaming ? "pause.fill" : "play.fill")
            }
            .tintColorSet(theme.colorTheme.primary)
          }
        }
    }
  }
  
  private func toggleStreaming() {
    if vm.isStreaming {
      vm.cancelStream()
    } else {
      Task {
        await vm.startStream(patient: patient)
      }
    }
  }
  
  private func errorTitle(_ error: HeatmapVMError) -> LocalizedStringResource {
    switch error {
    case .fetchHeatmapFailed:
      return "히트맵 정보를 불러올 수 없어요."
    case .noDevice:
      return "장치를 찾을 수 없어요."
    case .noPatient:
      return "환자 정보를 찾을 수 없어요."
    }
  }
  
  private func pressureColor(for value: Int, min: Int, max: Int) -> Color {
    guard max > min else {
        return value > 0 ? Color.red.opacity(0.7) : Color.gray.opacity(0.4)
    }
    let normalized = Double(value - min) / Double(max - min)
    switch normalized {
    case let ratio where ratio >= 0.66:
        return Color.red.opacity(0.8)
    case let ratio where ratio >= 0.33:
        return Color.orange.opacity(0.4)
    case let ratio where ratio >= 0.11:
        return Color.yellow.opacity(0.05)
    default:
        return Color.gray.opacity(0.02)
    }
  }
}

#Preview {
    HeatmapView(
      patient: Patient(
        id: 2625083234860015468, createdAt: .now,
        uid: UUID(uuidString: "d9542f41-2177-4522-a833-b48afeff8b19")!,
        name: "",
        occiputThreshold: nil,
        scapulaThreshold: nil,
        rightElbowThreshold: nil,
        leftElbowThreshold: nil,
        hipThreshold: nil,
        rightHeelThreshold: nil,
        leftHeelThreshold: nil
      )
    )
}
