//
//  DayLogsViewModel.swift
//  BedSolution
//
//  Created by 이재호 on 11/3/25.
//

import Foundation
import Logging

enum DayLogsVMError: LocalizedError {
  /// 환자정보가 서버에 없음
  case noPateint
  /// 장치 정보가 없음
  case noDeviceID
  /// 내부 오류
  case internalError
}

@Observable
class DayLogsViewModel {
  private(set) var dayLogs: [DayLog] = []
  private(set) var error: DayLogsVMError?
  
  private let patientRepo = PatientRepository()
  private let dayLogRepo = DayLogRepository()
  private var fetchDayLogsTask: Task<Void, Never>?
  private let logger = Logger(label: "DayLogsViewModel")
  
  func fetchDayLogs(patient: Patient) async {
    fetchDayLogsTask?.cancel()
    fetchDayLogsTask = Task { [weak self] in
      guard let self else { return }
      
      do {
        let patient = try await self.patientRepo.get(filter: .init(uid: patient.uid, id: patient.id))
        guard let patient else { throw DayLogsVMError.noPateint }
        guard let deviceID = patient.deviceID else { throw DayLogsVMError.noDeviceID }
        self.dayLogs = try await self.dayLogRepo.list(
          filter: .init(deviceID: deviceID),
          limit: nil
        )
      } catch {
        self.logger.error("Fail to fetch day logs: \(error)")
        if let vmError = error as? DayLogsVMError {
          self.error = vmError
        } else {
          self.error = .internalError
        }
      }
    }
  }
}
