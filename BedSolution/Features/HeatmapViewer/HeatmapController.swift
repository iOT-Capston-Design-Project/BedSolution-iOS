//
//  HeatmapController.swift
//  BedSolution
//
//  Created by 이재호 on 9/23/25.
//

import Foundation
import Logging

@Observable
final class HeatmapController {
    private enum Constants {
        static let rows = 14
        static let columns = 7
        static let cellCount = rows * columns
    }
    
    private let repository = HeatmapRepository()
    private let logger = Logger(label: "HeatmapController")
    
    private var streamTask: Task<Void, Never>?
    private var currentDeviceID: Int?
    
    private(set) var values: [[Int]]
    private(set) var isLoading = false
    private(set) var lastUpdated: Date?
    private(set) var errorMessage: String?
    
    init(initialValues: [[Int]] = []) {
        if initialValues.isEmpty {
            self.values = []
        } else {
            let flattened = Array(initialValues.joined())
            self.values = Self.reshape(flattened)
            self.lastUpdated = .now
        }
    }
    
    deinit {
        streamTask?.cancel()
    }
    
    @MainActor
    func connectToDevice(deviceID: Int) {
        if currentDeviceID != deviceID {
            values = []
        }
        currentDeviceID = deviceID
        isLoading = true
        errorMessage = nil
        lastUpdated = nil
        streamTask?.cancel()
        streamTask = Task { [weak self] in
            await self?.listen(for: deviceID)
        }
        logger.info("Subscribed to heatmap stream for device: \(deviceID)")
    }
    
    @MainActor
    func disconnectFromDevice() {
        streamTask?.cancel()
        streamTask = nil
        logger.info("Disconnected heatmap stream for device: \(currentDeviceID ?? -1)")
        currentDeviceID = nil
    }
    
    private func listen(for deviceID: Int) async {
        let stream = repository.stream(filter: .init(deviceID: deviceID))
        for await heatmap in stream {
            if Task.isCancelled { break }
            update(with: heatmap, expectedDeviceID: deviceID)
        }
        if Task.isCancelled { return }
        await MainActor.run {
            if self.currentDeviceID == deviceID {
                self.isLoading = false
                if self.values.isEmpty {
                    self.errorMessage = "실시간 데이터가 수신되지 않았습니다."
                }
            }
        }
    }
    
    @MainActor
    private func update(with heatmap: Heatmap, expectedDeviceID: Int) {
        guard currentDeviceID == expectedDeviceID else { return }
        let grid = Self.reshape(heatmap.sensors)
        if grid != values {
            values = grid
        }
        logger.info("Heatmap updated")
        lastUpdated = .now
        isLoading = false
        errorMessage = nil
    }
    
    private static func reshape(_ sensors: [Int]) -> [[Int]] {
        var buffer = sensors
        if buffer.count < Constants.cellCount {
            buffer.append(contentsOf: Array(repeating: 0, count: Constants.cellCount - buffer.count))
        } else if buffer.count > Constants.cellCount {
            buffer = Array(buffer.prefix(Constants.cellCount))
        }
        if buffer.isEmpty {
            return []
        }
        return stride(from: 0, to: buffer.count, by: Constants.columns).map { index in
            let end = index + Constants.columns
            return Array(buffer[index..<end])
        }
    }
}
