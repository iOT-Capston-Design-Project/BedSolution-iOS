//
//  PostureLogRepository.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import Foundation
import Supabase

final class PostureLogRepository: RWRepository {
    typealias Element = PostureLog
    
    struct Filter {
        var minDate: Date?
        var dayID: Int?
        var id: Int?
    }
    
    nonisolated private struct PostureLogDTO: Encodable {
        public let id: Int
        public let createdAt: Date
        public let memo: String?
        public let imgURL: String?
        public let dayID: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case memo
            case imgURL = "img_url"
            case dayID = "day_id"
        }
        
        init(origin: PostureLog) {
            self.id = origin.id
            self.createdAt = origin.createdAt
            self.memo = origin.memo
            self.imgURL = origin.imgURL
            self.dayID = origin.dayID
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(createdAt, forKey: .createdAt)
            try container.encodeIfPresent(memo, forKey: .memo)
            try container.encodeIfPresent(imgURL, forKey: .imgURL)
            try container.encodeIfPresent(dayID, forKey: .dayID)
        }
    }
    
    let table: String = "posture_change_logs"
    private let client: SupabaseClient
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    @discardableResult
    func upsert(_ element: PostureLog) async throws -> Data {
        let dto = PostureLogDTO(origin: element)
        let response = try await client.from(table)
            .upsert(dto, onConflict: "id", returning: .representation)
            .execute()
        return  response.data
    }
    
    func get(filter: Filter?) async throws -> PostureLog? {
        guard let filter else { return nil }
        let response = try await buildFilter(filter: filter).limit(1).execute()
        return try JSONDecoder().decode([PostureLog].self, from: response.data).first
    }
    
    func list(filter: Filter?, limit: Int?) async throws -> [PostureLog] {
        var builder: PostgrestFilterBuilder!
        if let filter {
            builder = buildFilter(filter: filter)
        } else {
            builder = client.from(table).select()
        }
        var response: PostgrestResponse<Void>!
        if let limit {
            response = try await builder.limit(limit).execute()
        } else {
            response = try await builder.execute()
        }
        return try JSONDecoder().decode([PostureLog].self, from: response.data)
    }
    
    func count(filter: Filter?) async throws -> Int {
        if let filter {
            return try await buildFilter(filter: filter, head: true).execute().count ?? 0
        } else {
            return try await client.from(table).select(head: true).execute().count ?? 0
        }
    }
    
    private func buildFilter(filter: Filter, head: Bool = false) -> PostgrestFilterBuilder {
        var builder = client.from(table).select(head: head)
        if let dayID = filter.dayID {
            builder = builder.eq("day_id", value: dayID)
        }
        if let id = filter.id {
            builder = builder.eq("id", value: id)
        }
        if let date = filter.minDate {
            builder = builder.gt("date", value: date.formatted(.iso8601))
        }
        return builder
    }
}
