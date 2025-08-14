//
//  PatientRepository.swift
//  BedSolution
//
//  Created by 이재호 on 8/13/25.
//

import Foundation
import Logging
import Supabase

final class PatientRepository: RWRepository {
    typealias Element = Patient
    
    struct Filter {
        var uid: UUID
        var id: Int?
    }
    
    nonisolated private struct PatientDTO: Encodable {
        let id: Int
        let createdAt: Date
        let updatedAt: Date?
        let uid: UUID
        let name: String
        let height: Float?
        let weight: Float?
        let cautionOcciput: Bool
        let cautionScapula: Bool
        let cautionElbow: Bool
        let cautionHip: Bool
        let cautionHeel: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case uid
            case name
            case height
            case weight
            case cautionOcciput = "caution_occiput"
            case cautionScapula = "caution_scapula"
            case cautionElbow = "caution_elbow"
            case cautionHip = "caution_hip"
            case cautionHeel = "caution_heel"
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(createdAt, forKey: .createdAt)
            try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
            try container.encode(uid, forKey: .uid)
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(height, forKey: .height)
            try container.encodeIfPresent(weight, forKey: .weight)
            try container.encode(cautionOcciput, forKey: .cautionOcciput)
            try container.encode(cautionScapula, forKey: .cautionScapula)
            try container.encode(cautionElbow, forKey: .cautionElbow)
            try container.encode(cautionHip, forKey: .cautionHip)
            try container.encode(cautionHeel, forKey: .cautionHeel)
        }
        
        init(origin: Patient) {
            self.id = origin.id
            self.createdAt = origin.createdAt
            self.updatedAt = origin.updatedAt
            self.uid = origin.uid
            self.name = origin.name
            self.height = origin.height
            self.weight = origin.weight
            self.cautionOcciput = origin.cautionOcciput
            self.cautionScapula = origin.cautionScapula
            self.cautionElbow = origin.cautionElbow
            self.cautionHip = origin.cautionHip
            self.cautionHeel = origin.cautionHeel
        }
    }
    
    let table: String = "patients"
    private let client: SupabaseClient
    private let logger = Logger(label: "PatientRepository")
    
    init(client: SupabaseClient) {
        self.client = client
    }
    
    @discardableResult
    func upsert(_ element: Patient) async throws -> Data {
        let dto = PatientDTO(origin: element)
        let response = try await client
            .from(table)
            .upsert(dto, onConflict: "id", returning: .representation)
            .execute()
        return response.data
    }
    
    func get(filter: Filter?) async throws -> Patient? {
        guard let filter else { return nil }
        let response = try await buildFilter(filter).limit(1).execute()
        return try JSONDecoder().decode([Patient].self, from: response.data).first
    }
    
    func list(filter: Filter?, limit: Int?) async throws -> [Patient] {
        guard let filter else { return [] }
        var builder = buildFilter(filter).order("name")
        if let limit {
            builder = builder.limit(limit)
        }
        let response = try await builder.execute()
        return try JSONDecoder().decode([Patient].self, from: response.data)
    }
    
    func count(filter: Filter?) async throws -> Int {
        guard let filter else { return 0 }
        let response = try await buildFilter(filter, head: true).execute()
        return response.count ?? 0
    }
    
    private func buildFilter(_ filter: Filter, head: Bool = false) -> PostgrestFilterBuilder {
        var builder = client.from(table)
            .select(head: head)
            .eq("uid", value: filter.uid)
        if let id = filter.id {
            builder = builder.eq("id", value: id)
        }
        return builder
    }
}
