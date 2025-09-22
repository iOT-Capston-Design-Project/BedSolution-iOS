//
//  PastLogsController.swift
//  BedSolution
//
//  Created by 이재호 on 9/19/25.
//

import Foundation
import Logging

@Observable
class PastLogsController {
    private(set) var dayLogs: [DayLog] = []
    private(set) var isLoading: Bool = false
    private(set) var isFailed: Bool = false
    private let daylogRepository = DayLogRepository()
    private let logger = Logger(label: "PastLogsController")
    private var deviceID: Int?
    
    init() {}
    
    func refresh(deviceID: Int?) async {
        self.deviceID = deviceID
        await fetchDayLogs()
    }
    
    private func fetchDayLogs() async {
        guard let deviceID else {
            dayLogs = []
            logger.warning("Devilce ID is nil")
            return
        }
        
        defer {
            isLoading = false
        }
        
        isFailed = false
        isLoading = true
        do {
            dayLogs =  try await daylogRepository.list(
                filter: .init(deviceID: deviceID),
                limit: nil
            )
        } catch {
            logger.error("Failed to fetch day logs \(error.localizedDescription)")
            isFailed = true
        }
    }
}
