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
        let occiputThreshold: Int?
        let scapulaThreshold: Int?
        let rightElbowThreshold: Int?
        let leftElbowThreshold: Int?
        let hipThreshold: Int?
        let rightHeelThreshold: Int?
        let leftHeelThreshold: Int?
        let deviceID: Int?
        
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case uid
            case name
            case height
            case weight
            case occiputThreshold = "occiput_threshold"
            case scapulaThreshold = "scapula_threshold"
            case rightElbowThreshold = "relbow_threshold"
            case leftElbowThreshold = "lelbow_threshold"
            case hipThreshold = "hip_threshold"
            case rightHeelThreshold = "rheel_threshold"
            case leftHeelThreshold = "lheel_threshold"
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
            try container.encodeIfPresent(occiputThreshold, forKey: .occiputThreshold)
            try container.encodeIfPresent(scapulaThreshold, forKey: .scapulaThreshold)
            try container.encodeIfPresent(rightElbowThreshold, forKey: .rightElbowThreshold)
            try container.encodeIfPresent(leftElbowThreshold, forKey: .leftElbowThreshold)
            try container.encodeIfPresent(hipThreshold, forKey: .hipThreshold)
            try container.encodeIfPresent(rightHeelThreshold, forKey: .rightHeelThreshold)
            try container.encodeIfPresent(leftHeelThreshold, forKey: .leftHeelThreshold)
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
            self.occiputThreshold = origin.occiputThreshold
            self.scapulaThreshold = origin.scapulaThreshold
            self.rightElbowThreshold = origin.rightElbowThreshold
            self.leftElbowThreshold = origin.leftElbowThreshold
            self.hipThreshold = origin.hipThreshold
            self.rightHeelThreshold = origin.rightHeelThreshold
            self.leftHeelThreshold = origin.leftHeelThreshold
            self.deviceID = origin.deviceID
        }
    }
    
    let table: String = "patients"
    private let client = SupabaseService.shared.client
    private let logger = Logger(label: "PatientRepository")
    
    init() {}
    
    @discardableResult
    func insert(_ element: Patient) async throws -> Data {
        var mutableElement = element
        if mutableElement.id == 0 {
            mutableElement.id = Int(IDGenerator.generateInt64(from: mutableElement.uid))
        }
        let dto = PatientDTO(origin: mutableElement)
        let response = try await client
            .from(table)
            .insert(dto, returning: .representation)
            .execute()
        return response.data
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
        return try SupabaseService.shared.jsonDecoder.decode([Patient].self, from: response.data).first
    }
    
    func list(filter: Filter?, limit: Int?) async throws -> [Patient] {
        guard let filter else { return [] }
        var builder = buildFilter(filter).order(Patient.CodingKeys.name.rawValue)
        if let limit {
            builder = builder.limit(limit)
        }
        let response = try await builder.execute()
        do {
            return try SupabaseService.shared.jsonDecoder.decode([Patient].self, from: response.data)
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
    
    @discardableResult
    func delete(id: Int) async throws -> Data {
        let response = try await client
            .from(table)
            .delete()
            .eq(Patient.CodingKeys.id.rawValue, value: id)
            .execute()
        return response.data
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

