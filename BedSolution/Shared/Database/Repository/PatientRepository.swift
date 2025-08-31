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
        let deviceID: Int?
        
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
            case deviceID = "device_id"
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
            try container.encodeIfPresent(deviceID, forKey: .deviceID)
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
            self.deviceID = origin.deviceID
        }
    }
    
    let table: String = "patients"
    private let client: SupabaseClient
    private let logger = Logger(label: "PatientRepository")
    
    init() {
        guard let baseURL = APIConfiguration.shared.baseURL, let apiKey = APIConfiguration.shared.apiKey else {
            fatalError("No API key or base URL set")
        }
        self.client = SupabaseClient(supabaseURL: baseURL, supabaseKey: apiKey)
    }
    
    @discardableResult
    func upsert(_ element: Patient) async throws -> Data {
        let dto = PatientDTO(origin: element)
        let response = try await client
            .from(table)
            .upsert(dto, onConflict: Patient.CodingKeys.id.rawValue, returning: .representation)
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
        var builder = buildFilter(filter).order(Patient.CodingKeys.name.rawValue)
        if let limit {
            builder = builder.limit(limit)
        }
        let response = try await builder.execute()
        do {
            return try JSONDecoder().decode([Patient].self, from: response.data)
        } catch {
            logger.critical("Fail to decode Patient from JSON", metadata: ["error": .string(error.localizedDescription)])
            throw error
        }
    }
    
    func count(filter: Filter?) async throws -> Int {
        guard let filter else { return 0 }
        let response = try await buildFilter(filter, head: true).execute()
        if let count = response.count {
            return count
        }
        logger.error("No count field in the response", metadata: ["response": .stringConvertible(response.response)])
        return 0
    }
    
    private func buildFilter(_ filter: Filter, head: Bool = false, count: CountOption = .exact) -> PostgrestFilterBuilder {
        var builder = client.from(table)
            .select(head: head, count: head ? count: nil)
            .eq(Patient.CodingKeys.uid.rawValue, value: filter.uid)
        if let id = filter.id {
            builder = builder.eq(Patient.CodingKeys.id.rawValue, value: id)
        }
        return builder
    }
}
