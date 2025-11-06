//
//  PatientInfoViewModel.swift
//  BedSolution
//
//  Created by 이재호 on 11/3/25.
//

import Foundation
import Logging
import FirebaseMessaging

enum PatientInfoVMError: LocalizedError {
  /// 환자 정보 불러오기 실패
  case fetchPatientFailed
  /// 서버에 등록된 환자가 없는 경우
  case noPatient
  /// 서버에 환자 정보 업데이트 실패
  case patientUpdateFailed
  /// 서버에 등록된 디바이스가 없는 경우
  case invalidDevice
  /// Messaging등록 실패
  case messagingRegistrationFailed
  case unknown
}

@Observable
class PatientInfoViewModel {
  // MARK: - 환자 정보
  var name: String = ""
  var weight: Float?
  /// 후두부 시간
  var occiputTime: Int?
  /// 견갑골 시간
  var scapulaTime: Int?
  /// 우측 팔꿈치 시간
  var rightElbowTime: Int?
  /// 좌측 팔꿈치 시간
  var leftElbowTime: Int?
  /// 엉덩이 시간
  var hipTime: Int?
  /// 우측 발꿈치 시간
  var rightHeelTime: Int?
  /// 좌측 발꿈치 시간
  var leftHeelTime: Int?
  var deviceID: Int?
  private var origin: Patient?
  
  // MARK: - 편집을 위한 부가적인 정보
  /// 편집 모드 여부
  var isEditing: Bool = false
  /// 편집 가능 여부
  var isEditable: Bool {
    origin != nil
  }
  /// 변경 여부
  var isUpdated: Bool {
    guard let origin else { return false }
    return origin.name != name || origin.weight != weight ||
    origin.occiputThreshold != occiputTime ||
    origin.scapulaThreshold != scapulaTime ||
    origin.rightElbowThreshold != rightElbowTime ||
    origin.leftElbowThreshold != leftElbowTime ||
    origin.hipThreshold != hipTime ||
    origin.rightHeelThreshold != rightHeelTime ||
    origin.leftHeelThreshold != leftHeelTime ||
    origin.deviceID != deviceID
  }
  /// 업데이트 플래그
  private(set) var isUpdating: Bool = false
  private(set) var error: PatientInfoVMError?
  
  
  // MARK: - 로직처리를 위한 내부 변수
  private let patientRepo = PatientRepository()
  private let deviceRepo = DeviceRepository()
  private var deviceValidTask: Task<Void, Never>?
  private let logger = Logger(label: "PatientInfoViewModel")
  
  // MARK: - 환자 정보 업데이트를 위한 함수
  
  /// 서버로부터 환자정보를 불러와 업데이트합니다.
  func initialize(patientID: Int, uid: UUID) async {
    do {
      if let patient = try await patientRepo.get(filter: .init(uid: uid, id: patientID)) {
        initialize(with: patient)
      } else {
        logger.warning("No patient found with id: \(patientID)")
        error = PatientInfoVMError.noPatient
      }
    } catch {
      logger.error("Fail to get patient: \(error.localizedDescription)")
      self.error = PatientInfoVMError.fetchPatientFailed
    }
  }
  
  /// 해당 뷰 모델의 환자정보를 업데이트합니다. 화면 로드시에는 서버에서 정보를 불러와야하므로 해당 함수를 사용하면 안됩니다.
  private func initialize(with patient: Patient) {
    // TODO: 변경된 속성 적용하기
    self.origin = patient
    self.name = patient.name
    self.weight = patient.weight
    self.occiputTime = patient.occiputThreshold
    self.scapulaTime = patient.scapulaThreshold
    self.rightElbowTime = patient.rightElbowThreshold
    self.leftElbowTime = patient.leftElbowThreshold
    self.hipTime = patient.hipThreshold
    self.rightHeelTime = patient.rightHeelThreshold
    self.leftHeelTime = patient.leftHeelThreshold
    self.deviceID = patient.deviceID
  }
  
  /// 사용자가 등록한 디바이스가 올바른 아이디를 가졌는지 확인
  private func isValidDeviceID() async -> Bool {
    if let deviceID {
      do {
        let count = try await deviceRepo.count(filter: .init(deviceID: deviceID))
        return count == 1
      } catch {
        logger.error("Fail to fetch device with id(\(deviceID))")
        return false
      }
    }
    return true
  }
  
  /// 클라우드 메시지에 디바이스 ID 주제를 구독합니다.
  private func subscribeDeviceNotification(originID: Int?, updatedID: Int?) async throws {
    do {
      if let originID {
        try await Messaging.messaging().unsubscribe(fromTopic: String(originID))
      }
      if let updatedID {
        try await Messaging.messaging().subscribe(toTopic: String(updatedID))
      }
    } catch {
      logger.error("Fail to register/unregister device topic: \(error.localizedDescription)")
      throw PatientInfoVMError.messagingRegistrationFailed
    }
  }
  
  /// 환자 정보를 업데이트합니다.
  @discardableResult
  private func updatePatient() async throws -> Patient? {
    guard let origin else { return nil }
    do {
      let updated = Patient(
        id: origin.id,
        createdAt: origin.createdAt, updatedAt: .now,
        uid: origin.uid,
        name: name,
        height: nil, weight: weight,
        occiputThreshold: occiputTime,
        scapulaThreshold: scapulaTime,
        rightElbowThreshold: rightElbowTime,
        leftElbowThreshold: leftElbowTime,
        hipThreshold: hipTime,
        rightHeelThreshold: rightHeelTime,
        leftHeelThreshold: leftHeelTime,
        deviceID: deviceID
      )
      try await patientRepo.upsert(updated)
      return updated
    } catch {
      logger.error("Fail to update patient: \(error.localizedDescription)")
      throw PatientInfoVMError.patientUpdateFailed
    }
  }
  
  func update() async {
    guard isUpdated else { return }
    guard let origin else { return }
    isUpdating = true
    defer { isUpdating = false }
    do {
      guard await isValidDeviceID() else { throw PatientInfoVMError.invalidDevice }
      let updated = try await updatePatient()
      try await subscribeDeviceNotification(
        originID: origin.deviceID,
        updatedID: updated?.deviceID
      )
      if let updated {
        initialize(with: updated)
      }
    } catch let error {
      logger.error("Fail to update patient: \(error.localizedDescription)")
      if let vmError = error as? PatientInfoVMError {
        if vmError != .messagingRegistrationFailed {
          initialize(with: origin)
        }
        self.error = vmError
      } else {
        self.error = .unknown
      }
    }
  }
  
  func togglEditigMode() {
    isEditing.toggle()
  }
}
