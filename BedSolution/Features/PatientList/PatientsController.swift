//
//  PatientListController.swift
//  BedSolution
//

import Foundation
import Logging
import FirebaseMessaging

@Observable
final class PatientsController {
    private let logger = Logger(label: "PatientListController")
    private let repo = PatientRepository()

    private(set) var patients: [Patient] = []
    
    private func registerForRemoteNotifications(deviceID: Int?) {
        guard let deviceID else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                try await Messaging.messaging().subscribe(toTopic: String(deviceID))
            } catch {
                self.logger.error("Fail to register for remote notifications: \(error.localizedDescription)")
            }
        }
    }
    
    private func unregisterForRemoteNotifications(deviceID: Int?) {
        guard let deviceID else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                try await Messaging.messaging().unsubscribe(fromTopic: String(deviceID))
            } catch {
                self.logger.error("Fail to unregister for remote notifications: \(error.localizedDescription)")
            }
        }
    }

    func refresh(uid: UUID) async {
        do {
            self.patients = try await repo.list(filter: .init(uid: uid), limit: nil)
        } catch {
            logger.error("Failed to fetch patients: \(error.localizedDescription)")
        }
    }
    
    func delete(_ patient: Patient) async {
        do {
            _ = try await repo.delete(id: patient.id)
            unregisterForRemoteNotifications(deviceID: patient.deviceID)
        } catch {
            logger.error("Failed to delete patient: \(error.localizedDescription)")
        }
    }
}
