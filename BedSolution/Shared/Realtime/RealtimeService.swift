//
//  RealtimeService.swift
//  BedSolution
//
//  Subscribe to Postgres changes using supabase-swift typed API (InsertAction/UpdateAction/DeleteAction).
//

import Foundation
import Supabase
import Logging

final class RealtimeService {
    static let shared = RealtimeService()
    private let client = SupabaseService.shared.client
    private let logger = Logger(label: "RealtimeService")

    private init() {}

    // Single patient by uid + id (client-side filter)
    func subscribePatient(uid: UUID, id: Int) -> AsyncStream<DBChange<Patient>> {
        let channel = client.channel("patient-\(id)")
        return AsyncStream { continuation in
            let insertions = channel.postgresChange(InsertAction.self, schema: "public", table: "patients")
            let updates = channel.postgresChange(UpdateAction.self, schema: "public", table: "patients")
            let deletions = channel.postgresChange(DeleteAction.self, schema: "public", table: "patients")

            let t1 = Task { for await ins in insertions {
                let row = ins.record
                if let u = row[Patient.CodingKeys.uid.rawValue]?.rawValue as? String,
                   let pid = row[Patient.CodingKeys.id.rawValue]?.rawValue as? Int,
                   u.lowercased() == uid.uuidString.lowercased(), pid == id,
                   let decoded = Patient(row: row) {
                    continuation.yield(DBChange(action: .inserted, record: decoded))
                }
            } }
            let t2 = Task { for await up in updates {
                let row = up.record
                if let u = row[Patient.CodingKeys.uid.rawValue]?.rawValue as? String,
                   let pid = row[Patient.CodingKeys.id.rawValue]?.rawValue as? Int,
                   u.lowercased() == uid.uuidString.lowercased(), pid == id,
                   let decoded = Patient(row: row) {
                    continuation.yield(DBChange(action: .updated, record: decoded))
                }
            } }
            let t3 = Task { for await del in deletions {
                let row = del.oldRecord
                if let u = row[Patient.CodingKeys.uid.rawValue]?.rawValue as? String,
                   let pid = row[Patient.CodingKeys.id.rawValue]?.rawValue as? Int,
                   u.lowercased() == uid.uuidString.lowercased(), pid == id,
                   let decoded = Patient(row: row) {
                    continuation.yield(DBChange(action: .deleted, record: decoded))
                }
            } }

            Task {
                do { try await channel.subscribeWithError() }
                catch { self.logger.error("patient subscribe failed: \(error.localizedDescription)") }
            }
            continuation.onTermination = { _ in
                t1.cancel(); t2.cancel(); t3.cancel()
                Task { await channel.unsubscribe() }
            }
        }
    }

    // Patients for a user (client-side filter by uid)
    func subscribePatients(uid: UUID) -> AsyncStream<DBChange<Patient>> {
        let channel = client.channel("patients-\(uid.uuidString)")
        return AsyncStream { continuation in
            let insertions = channel.postgresChange(InsertAction.self, schema: "public", table: "patients")
            let updates = channel.postgresChange(UpdateAction.self, schema: "public", table: "patients")
            let deletions = channel.postgresChange(DeleteAction.self, schema: "public", table: "patients")

            let t1 = Task { for await ins in insertions {
                let row = ins.record
                if let u = row[Patient.CodingKeys.uid.rawValue]?.rawValue as? String,
                   u.lowercased() == uid.uuidString.lowercased(),
                   let decoded = Patient(row: row) {
                    continuation.yield(DBChange(action: .inserted, record: decoded))
                }
            } }
            let t2 = Task { for await up in updates {
                let row = up.record
                if let u = row[Patient.CodingKeys.uid.rawValue]?.rawValue as? String,
                   u.lowercased() == uid.uuidString.lowercased(),
                   let decoded = Patient(row: row) {
                    continuation.yield(DBChange(action: .updated, record: decoded))
                }
            } }
            let t3 = Task { for await del in deletions {
                let row = del.oldRecord
                if let u = row[Patient.CodingKeys.uid.rawValue]?.rawValue as? String,
                   u.lowercased() == uid.uuidString.lowercased(),
                   let decoded = Patient(row: row) {
                    continuation.yield(DBChange(action: .deleted, record: decoded))
                }
            } }

            Task { do { try await channel.subscribeWithError() } catch { self.logger.error("patients subscribe failed: \(error.localizedDescription)") } }
            continuation.onTermination = { _ in
                t1.cancel(); t2.cancel(); t3.cancel()
                Task { await channel.unsubscribe() }
            }
        }
    }

    // DayLog: device + today (client-side filter)
    func subscribeTodayDayLog(deviceID: Int, serverToday: Date) -> AsyncStream<DBChange<DayLog>> {
        let channel = client.channel("day-logs-\(deviceID)")
        let dayOnly = SupabaseService.shared.formatDateOnly(serverToday)
        return AsyncStream { continuation in
            let insertions = channel.postgresChange(InsertAction.self, schema: "public", table: "day_logs")
            let updates = channel.postgresChange(UpdateAction.self, schema: "public", table: "day_logs")

            let t1 = Task { for await ins in insertions {
                let row = ins.record
                if let dev = row[DayLog.CodingKeys.deviceID.rawValue]?.rawValue as? Int,
                   dev == deviceID,
                   let decoded = DayLog(row: row),
                   SupabaseService.shared.formatDateOnly(decoded.day) == dayOnly {
                    continuation.yield(DBChange(action: .inserted, record: decoded))
                }
            } }
            let t2 = Task { for await up in updates {
                let row = up.record
                if let dev = row[DayLog.CodingKeys.deviceID.rawValue]?.rawValue as? Int,
                   dev == deviceID,
                   let decoded = DayLog(row: row),
                   SupabaseService.shared.formatDateOnly(decoded.day) == dayOnly {
                    continuation.yield(DBChange(action: .updated, record: decoded))
                }
            } }
            Task { do { try await channel.subscribeWithError() } catch { self.logger.error("day_logs subscribe failed: \(error.localizedDescription)") } }
            continuation.onTermination = { _ in
                t1.cancel(); t2.cancel()
                Task { await channel.unsubscribe() }
            }
        }
    }

    // Pressure logs for a day (client-side filter)
    func subscribePressureLogs(dayID: Int) -> AsyncStream<DBChange<PressureLog>> {
        let channel = client.channel("pressure-\(dayID)")
        return AsyncStream { continuation in
            let insertions = channel.postgresChange(InsertAction.self, schema: "public", table: "pressure_logs")
            let updates = channel.postgresChange(UpdateAction.self, schema: "public", table: "pressure_logs")
            let deletions = channel.postgresChange(DeleteAction.self, schema: "public", table: "pressure_logs")

            let t1 = Task { for await ins in insertions {
                let row = ins.record
                if let d = row[PressureLog.CodingKeys.dayID.rawValue]?.rawValue as? Int,
                   d == dayID,
                   let decoded = PressureLog(row: row) {
                    continuation.yield(DBChange(action: .inserted, record: decoded))
                }
            } }
            let t2 = Task { for await up in updates {
                let row = up.record
                if let d = row[PressureLog.CodingKeys.dayID.rawValue]?.rawValue as? Int,
                   d == dayID,
                   let decoded = PressureLog(row: row) {
                    continuation.yield(DBChange(action: .updated, record: decoded))
                }
            } }
            let t3 = Task { for await del in deletions {
                let row = del.oldRecord
                if let d = row[PressureLog.CodingKeys.dayID.rawValue]?.rawValue as? Int,
                   d == dayID,
                   let decoded = PressureLog(row: row) {
                    continuation.yield(DBChange(action: .deleted, record: decoded))
                }
            } }
            Task { do { try await channel.subscribeWithError() } catch { self.logger.error("pressure_logs subscribe failed: \(error.localizedDescription)") } }
            continuation.onTermination = { _ in
                t1.cancel(); t2.cancel(); t3.cancel()
                Task { await channel.unsubscribe() }
            }
        }
    }

    // Posture changes for a day & patient (client-side filter)
    func subscribeTodayPostureChanges(patientID: Int, dayID: Int) -> AsyncStream<DBChange<PostureLog>> {
        let channel = client.channel("posture-\(patientID)-\(dayID)")
        return AsyncStream { continuation in
            let insertions = channel.postgresChange(InsertAction.self, schema: "public", table: "posture_change_logs")
            let updates = channel.postgresChange(UpdateAction.self, schema: "public", table: "posture_change_logs")
            let deletions = channel.postgresChange(DeleteAction.self, schema: "public", table: "posture_change_logs")

            let t1 = Task { for await ins in insertions {
                let row = ins.record
                if let pid = row[PostureLog.CodingKeys.patientID.rawValue]?.rawValue as? Int,
                   let d = row[PostureLog.CodingKeys.dayID.rawValue]?.rawValue as? Int,
                   pid == patientID, d == dayID,
                   let decoded = PostureLog(row: row) {
                    continuation.yield(DBChange(action: .inserted, record: decoded))
                }
            } }
            let t2 = Task { for await up in updates {
                let row = up.record
                if let pid = row[PostureLog.CodingKeys.patientID.rawValue]?.rawValue as? Int,
                   let d = row[PostureLog.CodingKeys.dayID.rawValue]?.rawValue as? Int,
                   pid == patientID, d == dayID,
                   let decoded = PostureLog(row: row) {
                    continuation.yield(DBChange(action: .updated, record: decoded))
                }
            } }
            let t3 = Task { for await del in deletions {
                let row = del.oldRecord
                if let pid = row[PostureLog.CodingKeys.patientID.rawValue]?.rawValue as? Int,
                   let d = row[PostureLog.CodingKeys.dayID.rawValue]?.rawValue as? Int,
                   pid == patientID, d == dayID,
                   let decoded = PostureLog(row: row) {
                    continuation.yield(DBChange(action: .deleted, record: decoded))
                }
            } }
            Task { do { try await channel.subscribeWithError() } catch { self.logger.error("posture_change_logs subscribe failed: \(error.localizedDescription)") } }
            continuation.onTermination = { _ in
                t1.cancel(); t2.cancel(); t3.cancel()
                Task { await channel.unsubscribe() }
            }
        }
    }
}
