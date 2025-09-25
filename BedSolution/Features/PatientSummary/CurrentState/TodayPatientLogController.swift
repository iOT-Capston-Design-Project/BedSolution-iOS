//
//  CurrentStateController.swift
//  BedSolution
//
//  Created by 이재호 on 9/19/25.
//

import Foundation
import Logging

@Observable
final class TodayPatientLogController {
    private(set) var dayLog: DayLog?
    private(set) var pressureLogs: [PressureLog] = []
    private(set) var needPostureChange: Bool = false
    private(set) var warnedPressureLog: PressureLog?
    private let dayLogRepository = DayLogRepository()
    private let pressureLogRepository = PressureLogRepository()
    private let logger = Logger(label: "TodayPatientLogController")
    private var deviceID: Int?
    
    func fetch(deviceID: Int?) async {
        self.deviceID = deviceID
        if let log = await fetchDayLog() {
            await fetchPressureLogs(dayID: log.id)
        }
    }
    
    @discardableResult
    private func fetchDayLog() async -> DayLog? {
        guard let deviceID else { return nil }
        do {
            dayLog = try await dayLogRepository.get(filter: .init(deviceID: deviceID, day: .now))
            return dayLog
        } catch {
            logger.error("Failed to get today's day log. Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    private func fetchPressureLogs(dayID: Int) async -> [PressureLog] {
        do {
            var logs = try await pressureLogRepository.list(filter: .init(dayID: dayID), limit: nil)
            logs.sort(by: { $0.createdAt > $1.createdAt })
            self.pressureLogs = logs
            if let lastLog = logs.first, lastLog.needPostureChange {
                needPostureChange = lastLog.needPostureChange
                warnedPressureLog = lastLog
            } else {
                needPostureChange = false
                warnedPressureLog = nil
            }
            return pressureLogs
        } catch {
            return []
        }
    }
    
}
