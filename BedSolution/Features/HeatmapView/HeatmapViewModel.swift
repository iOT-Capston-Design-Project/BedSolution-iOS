//
//  HeatmapViewModel.swift
//  BedSolution
//
//  Created by 이재호 on 11/4/25.
//

import Foundation
import Logging

enum HeatmapVMError: LocalizedError {
  /// 환자 정보 없음
  case noPatient
  /// 디바이스 정보 없음
  case noDevice
  /// 히트맵 정보 불러오기 실패
  case fetchHeatmapFailed
}

@Observable
class HeatmapViewModel {
  enum HeatmapSize {
    static let rows = 14
    static let columns = 7
    static let cells = rows * columns
  }
  private(set) var heatmap: [[Int]] = []
  private(set) var latestUpdate: Date?
  private(set) var error: HeatmapVMError?
  var isStreaming: Bool {
    streamTask != nil
  }
  
  // MARK: - 내부 로직 처리를 위한 장치
  private let heatmapRepo = HeatmapRepository()
  private let patientRepo = PatientRepository()
  
  private var streamTask: Task<Void, Never>?
  private let logger = Logger(label: "HeatmapViewModel")
  
  deinit {
    streamTask?.cancel()
  }
  
  static private func reshape(_ sensors: [Int]) -> [[Int]] {
    var buffer = sensors
    if buffer.count < HeatmapSize.cells {
      buffer.append(contentsOf: Array(repeating: 0, count: HeatmapSize.cells-buffer.count))
    } else if buffer.count > HeatmapSize.cells {
      buffer = Array(buffer.prefix(HeatmapSize.cells))
    }
    if buffer.isEmpty { return [] }
    return stride(from: 0, to: buffer.count, by: HeatmapSize.columns).map { index in
      let end = index + HeatmapSize.columns
      return Array(buffer[index..<end])
    }
  }
  
  func cancelStream() {
    streamTask?.cancel()
    streamTask = nil
    error = nil
  }
  
  func startStream(patient: Patient) async {
    cancelStream()
    
    streamTask = Task { [weak self] in
      guard let self else { return }
      do {
        let patient = try await self.patientRepo.get(filter: .init(uid: patient.uid, id: patient.id))
        guard let patient else { throw HeatmapVMError.noPatient }
        guard let deviceID = patient.deviceID else { throw HeatmapVMError.noDevice }
        
        let stream = self.heatmapRepo.stream(filter: .init(deviceID: deviceID))
        for await input in stream {
          if Task.isCancelled { return }
          let grid = Self.reshape(input.sensors)
          await MainActor.run {
            self.heatmap = grid
            self.latestUpdate = Date.now
          }
        }
      } catch {
        self.logger.error("Fail to fetch heatmap: \(error)")
        if let vmError = error as? HeatmapVMError {
          self.error = vmError
        } else {
          self.error = HeatmapVMError.fetchHeatmapFailed
        }
      }
    }
  }
}
