//
//  CurrentStateController.swift
//  BedSolution
//
//  Created by 이재호 on 9/19/25.
//

import Foundation
import Logging

@Observable
final class TodayDayLogController {
    private(set) var dayLog: DayLog?
    private(set) var pressureLogs: [PressureLog] = []
    private let dayLogRepository = DayLogRepository()
    private let pressureLogRepository = PressureLogRepository()
    private let logger = Logger(label: "CurrentStateController")
    private var deviceID: Int?
    
    func initialize(deviceID: Int?) async {
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
            pressureLogs = try await pressureLogRepository.list(filter: .init(dayID: dayID), limit: nil)
            return pressureLogs
        } catch {
            return []
        }
    }
    
}
