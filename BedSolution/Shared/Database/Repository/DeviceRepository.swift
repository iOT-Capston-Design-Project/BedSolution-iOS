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
    
    init() {
        guard let baseURL = APIConfiguration.shared.baseURL, let apiKey = APIConfiguration.shared.apiKey else {
            fatalError("No API key or base URL set")
        }
        self.client = SupabaseClient(supabaseURL: baseURL, supabaseKey: apiKey)
    }
    
    func get(filter: Filter?) async throws -> Device? {
        guard let filter else { return nil }
        let response = try await buildFilter(filter).limit(1).execute()
        logger.info("Get response: \(response.response.statusCode)")
        return try JSONDecoder().decode([Device].self, from: response.data).first
    }
    
    func list(filter: Filter?, limit: Int?) async throws -> [Device] {
        var builder: PostgrestTransformBuilder!
        if let filter {
            builder = buildFilter(filter).order(Device.CodingKeys.createdAt.rawValue)
        } else {
            builder = client.from(table).select().order(Device.CodingKeys.createdAt.rawValue)
        }
        if let limit {
            builder = builder.limit(limit)
        }
        let response = try await builder.execute()
        logger.info("Get response: \(response.response.statusCode)")
        return try JSONDecoder().decode([Device].self, from: response.data)
    }
    
    func count(filter: Filter?) async throws -> Int {
        var builder: PostgrestTransformBuilder!
        if let filter {
            builder = buildFilter(filter, head: true).order(Device.CodingKeys.createdAt.rawValue)
        } else {
            builder = client.from(table).select(head: true, count: .exact).order(Device.CodingKeys.createdAt.rawValue)
        }
        let response = try await builder.execute()
        logger.info("Get response: \(response.response.statusCode)")
        return response.count ?? 0
    }
    
    private func buildFilter(_ filter: Filter, head: Bool = false, count: CountOption = .exact) -> PostgrestFilterBuilder {
        return client.from(table).select(head: head, count: head ? count: nil).eq(Device.CodingKeys.id.rawValue, value: filter.deviceID)
    }
}
