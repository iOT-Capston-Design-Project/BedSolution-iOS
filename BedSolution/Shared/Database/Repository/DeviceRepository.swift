//
//  DeviceRepository.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import Foundation
import Logging
import Supabase


final class DeviceRepository: ReadRepository {
    typealias Element = Device
    
    struct Filter {
        var deviceID: Int
    }
    
    let table: String = "devices"
    private let client: SupabaseClient
    private let logger = Logger(label: "DeviceRepository")
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    func get(filter: Filter?) async throws -> Device? {
        guard let filter else { return nil }
        let response = try await buildFilter(filter).limit(1).execute()
        logger.info("Get response: \(response.response.statusCode)")
        return try JSONDecoder().decode([Device].self, from: response.data).first
    }
    
    func list(filter: Filter?, limit: Int?) async throws -> [Device] {
        guard let filter else { return [] }
        var builder = buildFilter(filter).order("created_at")
        if let limit {
            builder = builder.limit(limit)
        }
        let response = try await builder.execute()
        logger.info("Get response: \(response.response.statusCode)")
        return try JSONDecoder().decode([Device].self, from: response.data)
    }
    
    func count(filter: Filter?) async throws -> Int {
        guard let filter else { return 0 }
        let response = try await buildFilter(filter, head: true).execute()
        logger.info("Get response: \(response.response.statusCode)")
        return response.count ?? 0
    }
    
    private func buildFilter(_ filter: Filter, head: Bool = false) -> PostgrestFilterBuilder {
        return client.from(table).select(head: head).eq("id", value: filter.deviceID)
    }
}
