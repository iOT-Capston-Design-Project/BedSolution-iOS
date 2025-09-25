//
//  DayLogController.swift
//  BedSolution
//
//  Created by 이재호 on 9/24/25.
//

import Foundation
import Logging

@Observable
final class DayLogController {
    enum DayLogState {
        case fetching
        case loaded
        case error
    }
    
    private let logger = Logger(label: "DayLogController")
    private let pressureRepo = PressureLogRepository()
    private let dayLogRepo = DayLogRepository()
    
    private var deviceID: Int?
    private var id: Int?
    
    private(set) var pressureLogs: [PressureLog] = []
    private(set) var state: DayLogState = .fetching
    
    private(set) var day: Date = .now
    private(set) var accumulatedOcciput: Int = 0
    private(set) var accumulatedScapula: Int = 0
    private(set) var accumulatedElbow: Int = 0
    private(set) var accumulatedHip: Int = 0
    private(set) var accumulatedHeel: Int = 0
    
    init() {}
    
    func fetch(deviceID: Int, id: Int) async {
        state = .fetching
        do {
            if let result = try await dayLogRepo.get(filter: .init(deviceID: deviceID, id: id)) {
                initialize(with: result)
                logger.info("Successfully fetched DayLog")
                await fetchPressureLogs()
                state = .loaded
            } else {
                logger.warning("No DayLog found")
                state = .error
            }
        } catch {
            logger.error("Failed to fetch daylog: \(error)")
            state = .error
        }
    }
    
    private func fetchPressureLogs() async {
        guard let id else { return }
        do {
            pressureLogs = try await pressureRepo.list(filter: .init(dayID: id), limit: nil)
            logger.info("Successfully fetched pressure logs")
        } catch {
            logger.error("Failed to fetch pressure logs: \(error)")
        }
    }
    
    private func initialize(with daylog: DayLog) {
        self.day = daylog.day
        self.accumulatedOcciput = daylog.accumulatedOcciput
        self.accumulatedScapula = daylog.accumulatedScapula
        self.accumulatedElbow = daylog.accumulatedElbow
        self.accumulatedHip = daylog.accumulatedHip
        self.accumulatedHeel = daylog.accumulatedHeel
        self.deviceID = daylog.deviceID
        self.id = daylog.id
    }
}
