//
//  DeviceRegisterController.swift
//  BedSolution
//
//  Created by 이재호 on 9/1/25.
//

import Foundation

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
                return nil
            }
        } catch {
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
            return false
        }
    }
}
