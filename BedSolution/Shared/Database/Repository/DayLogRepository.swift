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
        var day: Date?
        var minDate: Date?
        var maxDate: Date?
    }
    
    let table: String = "day_logs"
    private let client: SupabaseClient
    private let logger = Logger(label: "DayLogRepository")
    
    init() {
        guard let baseURL = APIConfiguration.shared.baseURL, let apiKey = APIConfiguration.shared.apiKey else {
            fatalError("No API key or base URL set")
        }
        self.client = SupabaseClient(supabaseURL: baseURL, supabaseKey: apiKey)
    }
    
    func get(filter: Filter?) async throws -> DayLog? {
        guard let filter else { return nil }
        let builder = buildFilter(filter).limit(1)
        let response = try await builder.execute()
        logger.info("Get response: \(response.response.statusCode)")
        return try JSONDecoder().decode([DayLog].self, from: response.data).first
    }
    
    func list(filter: Filter?, limit: Int?) async throws -> [DayLog] {
        guard let filter else { return [] }
        var builder = buildFilter(filter).order(DayLog.CodingKeys.day.rawValue)
        if let limit {
            builder = builder.limit(limit)
        }
        let response = try await builder.execute()
        logger.info("Get response: \(response.response.statusCode)")
        return try JSONDecoder().decode([DayLog].self, from: response.data)
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
        if let day = filter.day {
            builder = builder
                .eq(DayLog.CodingKeys.day.rawValue, value: day.formatted(.iso8601))
        } else if let minDate = filter.minDate, let maxDate = filter.maxDate {
            builder = builder
                .gt(DayLog.CodingKeys.day.rawValue, value: minDate.formatted(.iso8601))
                .lt(DayLog.CodingKeys.day.rawValue, value: maxDate.formatted(.iso8601))
        } else if let minDate = filter.minDate {
            builder = builder
                .gt(DayLog.CodingKeys.day.rawValue, value: minDate.formatted(.iso8601))
        } else if let maxDate = filter.maxDate {
            builder = builder
                .lt(DayLog.CodingKeys.day.rawValue, value: maxDate.formatted(.iso8601))
        }
        return builder
    }
}
