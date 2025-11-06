//
//  DayLogDetailViewModel.swift
//  BedSolution
//
//  Created by 이재호 on 11/4/25.
//

import Foundation
import Logging

enum DayLogDetailVMError: LocalizedError {
  case noDayLog
  case fetchPressureLogFailed
}

@Observable
class DayLogDetailViewModel {
  // MARK: - DayLog 속성
  private(set) var day: Date = .now
  private(set) var occiputTime: Int = 0
  private(set) var scapulaTime: Int = 0
  private(set) var rightElbowTime: Int = 0
  private(set) var leftElbowTime: Int = 0
  private(set) var hipTime: Int = 0
  private(set) var rightHeeelTime: Int = 0
  private(set) var leftHeelTime: Int = 0

  private(set) var pressureLogs: [PressureLog] = []
  
  // MARK: - 기타 속성
  private(set) var error: DayLogDetailVMError?
  
  // MARK: - 내부 로직 처리를 위한 변수
  private var dayLog: DayLog?
  private let dayLogRepo = DayLogRepository()
  private let pressureLogRepo = PressureLogRepository()
  private var fetchTask: Task<Void, Never>?
  private let logger = Logger(label: "DayLogDetailViewModel")
  
  func fetch(daylog: DayLog) async {
    fetchTask?.cancel()
    
    fetchTask = Task { [weak self] in
      guard let self else { return }
      do {
        let day = try await self.dayLogRepo.get(
          filter: .init(deviceID: daylog.deviceID, id: daylog.id)
        )
        guard let day else { throw DayLogDetailVMError.noDayLog }
        let logs = try await pressureLogRepo.list(filter: .init(dayID: day.id), limit: nil)
        self.dayLog = day
        self.occiputTime = day.totalOcciputTime
        self.scapulaTime = day.totalScapulaTime
        self.rightElbowTime = day.totalRightElbowTime
        self.leftElbowTime = day.totalLeftElbowTime
        self.rightHeeelTime = day.totalRightHeelTime
        self.leftHeelTime = day.totalLeftHeelTime
        self.hipTime = day.totalHipTime
        self.pressureLogs = logs
      } catch {
        if let vmError = error as? DayLogDetailVMError {
          self.error = vmError
        } else {
          self.error = .fetchPressureLogFailed
        }
      }
    }
  }
}
