//
//  HeatmapViewer.swift
//  BedSolution
//
//  Created by 이재호 on 9/23/25.
//

import SwiftUI

struct HeatmapViewer: View {
    @Environment(\.theme) private var theme
    private let deviceID: Int?
    @State private var controller = HeatmapController()

    private let defaultRows: Int = 14
    private let defaultColumns: Int = 7
    private let initialValue: [[Int]]

    init(deviceID: Int? = nil, initialValue: [[Int]] = []) {
        self.deviceID = deviceID
        self.initialValue = initialValue
    }
    
    private var aspectRatio: CGFloat {
        guard let firstRow = controller.values.first else {
            return CGFloat(defaultColumns) / CGFloat(defaultRows)
        }
        return CGFloat(firstRow.count) / CGFloat(controller.values.count)
    }
    
    private var heatmapGraphic: some View {
        GeometryReader { _ in
            Canvas { context, size in
                let data = controller.values
                guard !data.isEmpty else { return }
                let rows = data.count
                let columns = data.first?.count ?? 0
                guard columns > 0 else { return }
                let flattened = data.flatMap { $0 }
                let minValue = flattened.min() ?? 0
                let maxValue = flattened.max() ?? 0
                let cellWidth = size.width / CGFloat(columns)
                let cellHeight = size.height / CGFloat(rows)
                
                for rowIndex in 0..<rows {
                    for columnIndex in 0..<columns {
                        let rectOrigin = CGPoint(x: CGFloat(columnIndex) * cellWidth,
                                                 y: CGFloat(rowIndex) * cellHeight)
                        let rect = RoundedRectangle(cornerRadius: 12)
                            .path(in: CGRect(origin: rectOrigin, size: CGSize(width: cellWidth, height: cellHeight)))
                        let value = data[rowIndex][columnIndex]
                        let fillColor = color(for: value, min: minValue, max: maxValue)
                        context.fill(rect, with: .color(fillColor))
                    }
                }
            }
            .backgroundColorSet(theme.colorTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 12))
        }
    }
    
    @ViewBuilder
    private var overlay: some View {
        if deviceID == nil {
            overlayLabel("디바이스 ID가 필요합니다")
        } else if controller.isLoading && controller.values.isEmpty {
            ProgressView()
                .controlSize(.regular)
        } else if let message = controller.errorMessage {
            overlayLabel(message)
        } else if controller.values.isEmpty {
            overlayLabel("표시할 센서 데이터가 없습니다")
        }
    }

    private func overlayLabel(_ text: String) -> some View {
        Text(text)
            .textStyle(theme.textTheme.bodyMedium)
            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .backgroundColorSet(theme.colorTheme.surfaceContainerHigh, in: Capsule())
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                heatmapGraphic
                overlay
            }
            .animation(.easeInOut(duration: 0.25), value: controller.values)
            .frame(maxWidth: 280, maxHeight: 500)
            .aspectRatio(aspectRatio, contentMode: .fit)
            
            if let timestamp = controller.lastUpdated {
                HStack {
                    Text("최종 갱신:")
                    Text(timestamp, format: .dateTime.year(.omitted).month(.omitted).day(.omitted).hour().minute().second())
                        .contentTransition(.numericText())
                        .animation(.default, value: timestamp)
                }
                .textStyle(theme.textTheme.labelMedium)
                .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
            }
        }
        .task(id: deviceID) {
            guard let deviceID else { return }
            controller.connectToDevice(deviceID: deviceID)
        }
        .onDisappear {
            controller.disconnectFromDevice()
        }
    }
    
    private func color(for value: Int, min: Int, max: Int) -> Color {
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
    let sampleValues: [[Int]] = (0..<14).map { row in
        (0..<7).map { column in
            let base = 120.0
            let modulation = 30 * sin(Double(row) / 2) + 40 * cos(Double(column))
            return Int(base + modulation)
        }
    }
    return HeatmapViewer(deviceID: 2047364537)
        .padding()
        .background(Color(.systemBackground))
}
