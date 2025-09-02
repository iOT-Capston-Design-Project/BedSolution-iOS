//
//  DeviceRegisterController.swift
//  BedSolution
//
//  Created by 이재호 on 9/1/25.
//

import Foundation
import Logging

enum DeviceRegisterStep {
    case enterDeviceID
    case waitingForRegistration
    case registrationSuccess
    case registrationFailed
}

@Observable
class DeviceRegisterController {
    private(set) var current: DeviceRegisterStep = .enterDeviceID
    var deviceID: Int = 0
    private var deviceRepo: DeviceRepository
    private var patientRepo: PatientRepository
    private let logger = Logger(label: "DeviceRegisterController")
    
    init() {
        self.deviceRepo = DeviceRepository()
        self.patientRepo = PatientRepository()
    }
    
    func register(patient: Patient) {
        current = .waitingForRegistration
        Task {
            if let deviceID = await validateDevice() {
                if await linkWithPatient(deviceID: deviceID, patient: patient) {
                    current = .registrationSuccess
                } else {
                    current = .registrationFailed
                }
            } else {
                current = .registrationFailed
            }
        }
    }
    
    private func validateDevice() async -> Int? {
        do {
            if let device = try await deviceRepo.get(filter: .init(deviceID: deviceID)) {
                return device.id
            } else {
                logger.error("No device with ID: \(deviceID)")
                return nil
            }
        } catch {
            logger.error("Failed to get device: \(error)")
            return nil
        }
    }
    
    private func linkWithPatient(deviceID: Int, patient: Patient) async -> Bool {
        var mutablePatient = patient
        mutablePatient.deviceID = deviceID
        do {
            try await patientRepo.upsert(mutablePatient)
            return true
        } catch {
            logger.error("Failed to link device with patient: \(error)")
            return false
        }
    }
}
