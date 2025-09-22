//
//  PatientLogDetailController.swift
//  BedSolution
//

import Foundation
import Logging

@Observable
final class PatientLogDetailController {
    private let logger = Logger(label: "PatientLogDetailController")
    private let pressureRepo = PressureLogRepository()
    private let postureRepo = PostureLogRepository()

    private(set) var dayLog: DayLog
    private(set) var patient: Patient

    private(set) var pressureLogs: [PressureLog] = []
    private(set) var postureLogs: [PostureLog] = []
    private(set) var isLoading: Bool = false

    init(patient: Patient, dayLog: DayLog) {
        self.patient = patient
        self.dayLog = dayLog
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }
        do {
            pressureLogs = try await pressureRepo.list(filter: .init(id: nil, dayID: dayLog.id, minDate: nil), limit: nil)
            postureLogs = try await postureRepo.list(filter: .init(patientID: patient.id, minDate: nil, dayID: dayLog.id, id: nil), limit: nil)
        } catch {
            logger.error("Fail to load detail logs: \(error.localizedDescription)")
        }
    }
}

