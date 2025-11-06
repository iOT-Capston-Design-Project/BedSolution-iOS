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
  typealias Element = (Patient, DayLog, [PressureLog])
  
  /// 풀링 단위 (초)
  let interval: TimeInterval
  let patient: Patient
  
  func makeAsyncIterator() -> Iterator {
    Iterator(interval: interval, patient: patient)
  }
  
  struct Iterator: AsyncIteratorProtocol {
    typealias Element = (Patient, DayLog, [PressureLog])
    let interval: TimeInterval
    let patient: Patient
    private let patientRepo = PatientRepository()
    private let dayLogRepo = DayLogRepository()
    private let pressureLogRepo = PressureLogRepository()
    
    private func fetchPatient(patientID: Int, uid: UUID) async throws -> Patient? {
      do {
        let patient = try await patientRepo.get(filter: .init(uid: uid, id: patientID))
        return patient
      } catch {
        throw PatientStatusVMError.fetchPatientFailed
      }
    }
    
    func next() async throws -> (Patient, DayLog, [PressureLog])? {
      try await Task.sleep(for: .seconds(interval))
      guard let patient = try await fetchPatient(patientID: patient.id, uid: patient.uid) else {
        throw PatientStatusVMError.noPatient
      }
      guard let deviceID = patient.deviceID else { return nil }
      guard let dayLog = try await dayLogRepo.get(
        filter: .init(deviceID: deviceID, day: .now)
      ) else { throw PatientStatusVMError.noDayLog }
      do {
        let logs = try await pressureLogRepo.list(filter: .init(dayID: dayLog.id), limit: nil)
        return (patient, dayLog, logs)
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
  private(set) var isPostureChangeRequired: Bool = false
  
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
  
  deinit {
    cancelPullingTask()
  }
  
  private func updatePatient(patient: Patient) {
    self.patient = patient
    occiputThreshold = patient.occiputThreshold
    scapulaThreshold = patient.scapulaThreshold
    rightElbowThreshold = patient.rightElbowThreshold
    leftElbowThreshold = patient.leftElbowThreshold
    hipThreshold = patient.hipThreshold
    rightHeeelThreshold = patient.rightHeelThreshold
    leftHeelThreshold = patient.leftHeelThreshold
    name = patient.name
  }
  
  func cancelPullingTask() {
    pullingTask?.cancel()
    pullingTask = nil
  }
  
  private func startPullingTask() {
    pullingTask?.cancel()
    guard let patient else {
      logger.warning("Patient is not set. Cannot start pulling task")
      return
    }
    pullingTask = Task {
      do {
        for try await (patient, day, logs) in DayLogPullingSequence(interval: 10, patient: patient) {
          self.logger.info("Fetch recent day log")
          await MainActor.run {
            self.updatePatient(patient: patient)
            self.dayLog = day
            self.pressureLogs = logs.sorted(by: { $0.createdAt > $1.createdAt })
            let latestLog = pressureLogs.first
            occiputTime = latestLog?.occiputTime ?? 0
            scapulaTime = latestLog?.scapulaTime ?? 0
            rightElbowTime = latestLog?.leftElbowTime ?? 0
            leftElbowTime = latestLog?.rightElbowTime ?? 0
            hipTime = latestLog?.hipTime ?? 0
            rightHeeelTime = latestLog?.rightHeelTime ?? 0
            leftHeelTime = latestLog?.leftHeelTime ?? 0
            posture = latestLog?.postureType ?? .UKNOWN
            isPostureChangeRequired = latestLog?.needPostureChange ?? false
            latestUpdatedAt = .now
            if self.error != nil {
              self.error = nil
            }
          }
        }
      } catch {
        self.logger.error("Fail to fetch day log (\(error.localizedDescription))")
        if let vmError = error as? PatientStatusVMError {
          self.error = vmError
        } else {
          self.error = .fetchDayLogFailed
        }
      }
    }
  }
  
  func initialize(patient: Patient) async {
    self.patient = patient
    startPullingTask()
  }
}
