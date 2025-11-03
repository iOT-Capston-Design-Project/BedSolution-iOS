//
//  PatientStatusViewModel.swift
//  BedSolution
//
//  Created by 이재호 on 11/3/25.
//

import Foundation
import Logging

enum PatientStatusVMError: LocalizedError {
  /// 내부 오류
  case internalError
  /// 환자 정보 불러오기 실패
  case fetchPatientFailed
  /// 서버에 등록된 환자가 없는 경우
  case noPatient
  /// 압력 기록 불러오기 실패
  case fetchPressureLogFailed
  /// 날짜 기록 없음
  case noDayLog
  /// 디바이스 정보 없음
  case noDeviceID
  case fetchDayLogFailed
}

private struct DayLogPullingSequence: AsyncSequence {
  typealias AsyncIterator = Iterator
  typealias Element = (DayLog, [PressureLog])
  
  /// 풀링 단위 (초)
  let interval: TimeInterval
  let patient: Patient
  
  func makeAsyncIterator() -> Iterator {
    Iterator(interval: interval, patient: patient)
  }
  
  struct Iterator: AsyncIteratorProtocol {
    typealias Element = (DayLog, [PressureLog])
    let interval: TimeInterval
    let patient: Patient
    private let dayLogRepo = DayLogRepository()
    private let pressureLogRepo = PressureLogRepository()
    
    func next() async throws -> (DayLog, [PressureLog])? {
      try await Task.sleep(for: .seconds(interval))
      guard let deviceID = patient.deviceID else { return nil }
      guard let dayLog = try await dayLogRepo.get(
        filter: .init(deviceID: deviceID, day: .now)
      ) else { throw PatientStatusVMError.noDayLog }
      do {
        let logs = try await pressureLogRepo.list(filter: .init(dayID: dayLog.id), limit: nil)
        return (dayLog, logs)
      } catch {
        throw PatientStatusVMError.fetchPressureLogFailed
      }
    }
  }
}

@Observable
class PatientStatusViewModel {
  // MARK: - 사용자 정보
  private(set) var name: String = ""
  private(set) var occiputThreshold: Int?
  private(set) var scapulaThreshold: Int?
  private(set) var rightElbowThreshold: Int?
  private(set) var leftElbowThreshold: Int?
  private(set) var hipThreshold: Int?
  private(set) var rightHeeelThreshold: Int?
  private(set) var leftHeelThreshold: Int?
  private(set) var patient: Patient?
  
  // MARK: - 현재 압력
  private(set) var occiputTime: Int = 0
  private(set) var scapulaTime: Int = 0
  private(set) var rightElbowTime: Int = 0
  private(set) var leftElbowTime: Int = 0
  private(set) var hipTime: Int = 0
  private(set) var rightHeeelTime: Int = 0
  private(set) var leftHeelTime: Int = 0
  private(set) var posture: PostureType = .UKNOWN
  
  // MARK: - 오늘 날짜에 해당하는 기록들
  private(set) var pressureLogs: [PressureLog] = []
  private(set) var dayLog: DayLog?
  
  // MARK: - 부가 정보
  /// 현재 정보를 로딩중인지 확인
  private(set) var isLoading: Bool = false
  /// 사용에 영향을 미치는 오류들
  private(set) var error: PatientStatusVMError?
  private(set) var latestUpdatedAt: Date = .now
  
  // MARK: - 로직처리를 위한 내부 변수
  private let patientRepo = PatientRepository()
  private let pressureLogRepo = PressureLogRepository()
  private let dayLogRepo = DayLogRepository()
  
  private var pullingTask: Task<Void, Never>?
  private let logger = Logger(label: "PatientStatusViewModel")
  
  private func fetchPatient(patientID: Int, uid: UUID) async {
    do {
      let patient = try await patientRepo.get(filter: .init(uid: uid, id: patientID))
      if let patient {
        self.patient = patient
        occiputThreshold = patient.occiputTime
        scapulaThreshold = patient.scapulaTime
        rightElbowThreshold = patient.elbowTime
        leftElbowThreshold = patient.elbowTime
        hipThreshold = patient.hipTime
        rightHeeelThreshold = patient.heelTime
        leftHeelThreshold = patient.heelTime
        name = patient.name
      } else {
        self.error = PatientStatusVMError.noPatient
      }
    } catch {
      self.logger.error("Fail to fetch patient (\(error.localizedDescription))")
      self.error = PatientStatusVMError.fetchPatientFailed
    }
  }
  
  func cancelPullingTask() {
    pullingTask?.cancel()
  }
  
  private func startPullingTask() {
    pullingTask?.cancel()
    guard let patient else { return }
    pullingTask = Task {
      do {
        for try await (day, logs) in DayLogPullingSequence(interval: 10, patient: patient) {
          self.dayLog = day
          self.pressureLogs = logs.sorted(by: { $0.createdAt > $1.createdAt })
          let latestLog = pressureLogs.first
          occiputTime = latestLog?.occiput ?? 0
          scapulaTime = latestLog?.scapula ?? 0
          rightElbowTime = latestLog?.elbow ?? 0
          leftElbowTime = latestLog?.elbow ?? 0
          hipTime = latestLog?.hip ?? 0
          rightHeeelTime = latestLog?.heel ?? 0
          leftHeelTime = latestLog?.heel ?? 0
          posture = latestLog?.postureType ?? .UKNOWN
          latestUpdatedAt = .now
        }
      } catch {
        self.error = .fetchDayLogFailed
      }
    }
  }
  
  func initialize(patientID: Int, uid: UUID) async {
    await fetchPatient(patientID: patientID, uid: uid)
    startPullingTask()
  }
}
