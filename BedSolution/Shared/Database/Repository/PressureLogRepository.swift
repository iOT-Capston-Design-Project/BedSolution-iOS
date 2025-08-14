//
//  PressureLogRepository.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import Foundation
import Supabase

final class PressureLogRepository: ReadRepository {
    typealias Element = PressureLog
    
    struct Filter {
        var deviceID: Int
        var id: Int?
        var dayID: Int?
        var minDate: Date?
    }
    
    let table: String = "pressure_logs"
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    func get(filter: Filter?) async throws -> PressureLog? {
        guard let filter else { return nil }
        let response = try await buildFilter(filter).limit(1).execute()
        return try JSONDecoder().decode([PressureLog].self, from: response.data).first
    }
    
    func list(filter: Filter?, limit: Int?) async throws -> [PressureLog] {
        guard let filter else { return [] }
        var builder = self.buildFilter(filter).order("created_at")
        if let limit {
            builder = builder.limit(limit)
        }
        let response = try await builder.execute()
        return try JSONDecoder().decode([PressureLog].self, from: response.data)
    }
    
    func count(filter: Filter?) async throws -> Int {
        guard let filter else { return 0 }
        return try await self.buildFilter(filter, head: true).execute().count ?? 0
    }
    
    private func buildFilter(_ filter: Filter, head: Bool = false) -> PostgrestFilterBuilder {
        var builder = client.from(table).select(head: head)
            .eq("device_id", value: filter.deviceID)
        if let id = filter.id {
            builder = builder.eq("id", value: id)
        }
        if let dayID = filter.dayID {
            builder = builder.eq("day_id", value: dayID)
        }
        if let minDate = filter.minDate {
            builder = builder.gt("created_at", value: minDate.formatted(.iso8601))
        }
        return builder
    }
}
