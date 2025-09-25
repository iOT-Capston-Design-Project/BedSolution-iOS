//
//  DayLogRepository.swift
//  BedSolution
//
//  Created by 이재호 on 8/13/25.
//

import Foundation
import Logging
import Supabase

final class DayLogRepository: ReadRepository {
    typealias Element = DayLog
    
    struct Filter {
        var deviceID: Int
        var id: Int?
        var day: Date?
        var minDate: Date?
        var maxDate: Date?
    }
    
    let table: String = "day_logs"
    private let client = SupabaseService.shared.client
    private let logger = Logger(label: "DayLogRepository")
    
    init() {}
    
    func get(filter: Filter?) async throws -> DayLog? {
        guard let filter else { return nil }
        let builder = buildFilter(filter).limit(1)
        let response = try await builder.execute()
        logger.info("Get response: \(response.response.statusCode)")
        return try SupabaseService.shared.jsonDecoder.decode([DayLog].self, from: response.data).first
    }
    
    func list(filter: Filter?, limit: Int?) async throws -> [DayLog] {
        guard let filter else { return [] }
        var builder = buildFilter(filter).order(DayLog.CodingKeys.day.rawValue)
        if let limit {
            builder = builder.limit(limit)
        }
        let response = try await builder.execute()
        logger.info("Get response: \(response.response.statusCode)")
        return try SupabaseService.shared.jsonDecoder.decode([DayLog].self, from: response.data)
    }
    
    func count(filter: Filter?) async throws -> Int {
        guard let filter else { return 0 }
        let builder = buildFilter(filter, head: true)
        let response = try await builder.execute()
        logger.info("Get response: \(response.response.statusCode)")
        return response.count ?? 0
    }
    
    private func buildFilter(_ filter: Filter, head: Bool = false, count: CountOption = .exact) -> PostgrestFilterBuilder {
        var builder = client.from(table)
            .select(head: head, count: head ? count: nil)
            .eq(DayLog.CodingKeys.deviceID.rawValue, value: filter.deviceID)
        if let id = filter.id {
            builder = builder.eq(DayLog.CodingKeys.id.rawValue, value: id)
        }
        if let day = filter.day {
            let dayOnly = SupabaseService.shared.formatDateOnly(day)
            builder = builder
                .eq(DayLog.CodingKeys.day.rawValue, value: dayOnly)
        } else if let minDate = filter.minDate, let maxDate = filter.maxDate {
            let minStr = SupabaseService.shared.formatDateOnly(minDate)
            let maxStr = SupabaseService.shared.formatDateOnly(maxDate)
            builder = builder
                .gt(DayLog.CodingKeys.day.rawValue, value: minStr)
                .lt(DayLog.CodingKeys.day.rawValue, value: maxStr)
        } else if let minDate = filter.minDate {
            let minStr = SupabaseService.shared.formatDateOnly(minDate)
            builder = builder
                .gt(DayLog.CodingKeys.day.rawValue, value: minStr)
        } else if let maxDate = filter.maxDate {
            let maxStr = SupabaseService.shared.formatDateOnly(maxDate)
            builder = builder
                .lt(DayLog.CodingKeys.day.rawValue, value: maxStr)
        }
        return builder
    }
}
