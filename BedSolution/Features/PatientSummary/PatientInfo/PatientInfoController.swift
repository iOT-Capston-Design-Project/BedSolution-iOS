//
//  PatientInfoController.swift
//  BedSolution
//
//  Created by 이재호 on 9/19/25.
//

import Foundation
import Logging
import FirebaseMessaging

@Observable
final class PatientInfoController {
    enum DeviceIDState {
        case valid, invalid, checking
    }
    
    enum PatientInfoControllerError: Error {
        case noPatient
    }
    
    var name: String = ""
    var weight: Float? = nil
    var occiputTime: Int? = nil
    var scapulaTime: Int? = nil
    var elbowTime: Int? = nil
    var hipTime: Int? = nil
    var heelTime: Int? = nil
    var deviceID: Int? = nil
    private var origin: Patient?
    var patientID: Int? { origin?.id }
    var isUpdating: Bool = false
    var isFailed: Bool = false
    var deviceIDState: DeviceIDState = .valid
    var isUpdated: Bool {
        guard let origin else { return false }
        
        return name != origin.name || weight != origin.weight || occiputTime != origin.occiputTime || scapulaTime != origin.scapulaTime || elbowTime != origin.elbowTime || hipTime != origin.hipTime || heelTime != origin.heelTime || deviceID != origin.deviceID
    }
    private var isDeviceIDValidTask: Task<Void, Never>?
    private let deviceRepository = DeviceRepository()
    private let patientRepository = PatientRepository()
    private let logger = Logger(label: "PatientInfoController")
    
    init() {}
    
    func initialize(id: Int, uid: UUID) async {
        do {
            if let patient = try await patientRepository.get(filter: .init(uid: uid, id: id)) {
                initialize(with: patient)
            } else {
                logger.warning("No patient found with id: \(id)")
            }
        } catch {
            logger.error("Failure to get patient: \(error.localizedDescription)")
        }
    }
    
    func initialize(with patient: Patient) {
        self.origin = patient
        name = patient.name
        weight = patient.weight
        occiputTime = patient.occiputTime
        scapulaTime = patient.scapulaTime
        elbowTime = patient.elbowTime
        hipTime = patient.hipTime
        heelTime = patient.heelTime
        deviceID = patient.deviceID
        checkDeviceID()
    }
    
    func checkDeviceID() {
        if let deviceID {
            self.deviceIDState = .checking
            isDeviceIDValidTask?.cancel()
            isDeviceIDValidTask = Task { [weak self] in
                guard let self else {
                    self?.deviceIDState = .invalid
                    return
                }
                do {
                    let cnt = try await self.deviceRepository.count(filter: .init(deviceID: deviceID))
                    self.deviceIDState = cnt == 1 ? .valid: .invalid
                } catch {
                    self.deviceIDState = .invalid
                    self.logger.error("Failure to fetch device count: \(error.localizedDescription)")
                }
            }
        } else {
            self.deviceIDState = .valid
        }
    }
    
    private func subscribeDeviceNotification(originID: Int?, updatedID: Int?) async {
        do {
            if let updatedID {
                try await Messaging.messaging().subscribe(toTopic: String(updatedID))
                logger.info("Subscribed to device topic: \(updatedID)")
            }
            if let originID {
                try await Messaging.messaging().unsubscribe(fromTopic: String(originID))
                logger.info("Unsubscribed from device topic: \(originID)")
            }
        } catch {
            logger.error("Fail to subscribe to device topic: \(error.localizedDescription)")
        }
    }
    
    func update() async {
        guard let origin else { return }
        defer {
            isUpdating = false
        }
        isUpdating = true
        do {
            let updated = Patient(id: origin.id, createdAt: origin.createdAt, updatedAt: .now, uid: origin.uid, name: name, height: nil, weight: weight, occiputTime: occiputTime, scapulaTime: scapulaTime, elbowTime: elbowTime, hipTime: hipTime, heelTime: heelTime, deviceID: deviceID)
            try await patientRepository.upsert(updated)
            await subscribeDeviceNotification(originID: origin.deviceID, updatedID: updated.deviceID)
            initialize(with: updated)
        } catch {
            logger.error("Fail to update patient: \(error.localizedDescription)")
            initialize(with: origin)
            isFailed = true
        }
        
    }
}
