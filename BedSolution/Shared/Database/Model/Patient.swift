//
//  Patient.swift
//  BedSolution
//
//  Created by 이재호 on 8/13/25.
//

import Foundation
import Supabase

public struct Patient: Codable, Hashable, Identifiable {
    public var id: Int = 0
    public var createdAt: Date = Date()
    public var updatedAt: Date?
    public var uid: UUID = UUID()
    public var name: String = ""
    public var height: Float?
    public var weight: Float?
    public var occiputTime: Int?
    public var scapulaTime: Int?
    public var elbowTime: Int?
    public var hipTime: Int?
    public var heelTime: Int?
    public var deviceID: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case uid
        case name
        case height
        case weight
        case occiputTime = "occiput_time"
        case scapulaTime = "scapula_time"
        case elbowTime = "elbow_time"
        case hipTime = "hip_time"
        case heelTime = "heel_time"
        case deviceID = "device_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        let str = try container.decode(String.self, forKey: .createdAt)
        self.createdAt = try Date(try container.decode(String.self, forKey: .createdAt), strategy: .iso8601)
        let updatedAtStr = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        if let updatedAtStr {
            self.updatedAt = try Date(updatedAtStr, strategy: .iso8601)
        }
        self.uid = try container.decode(UUID.self, forKey: .uid)
        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decodeIfPresent(Float.self, forKey: .height)
        self.weight = try container.decodeIfPresent(Float.self, forKey: .weight)
        self.occiputTime = try container.decodeIfPresent(Int.self, forKey: .occiputTime)
        self.scapulaTime = try container.decodeIfPresent(Int.self, forKey: .scapulaTime)
        self.elbowTime = try container.decodeIfPresent(Int.self, forKey: .elbowTime)
        self.hipTime = try container.decodeIfPresent(Int.self, forKey: .hipTime)
        self.heelTime = try container.decodeIfPresent(Int.self, forKey: .heelTime)
        self.deviceID = try container.decodeIfPresent(Int.self, forKey: .deviceID)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encode(uid, forKey: .uid)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(height, forKey: .height)
        try container.encodeIfPresent(weight, forKey: .weight)
        try container.encodeIfPresent(occiputTime, forKey: .occiputTime)
        try container.encodeIfPresent(scapulaTime, forKey: .scapulaTime)
        try container.encodeIfPresent(elbowTime, forKey: .elbowTime)
        try container.encodeIfPresent(hipTime, forKey: .hipTime)
        try container.encodeIfPresent(heelTime, forKey: .heelTime)
        try container.encodeIfPresent(deviceID, forKey: .deviceID)
    }
    
    init() {}
    
    init?(row: [String: AnyJSON]) {
        do {
            let decoded = try SupabaseCoding.decode(Patient.self, from: row)
            self.id = decoded.id
            self.createdAt = decoded.createdAt
            self.updatedAt = decoded.updatedAt
            self.uid = decoded.uid
            self.name = decoded.name
            self.height = decoded.height
            self.weight = decoded.weight
            self.occiputTime = decoded.occiputTime
            self.scapulaTime = decoded.scapulaTime
            self.elbowTime = decoded.elbowTime
            self.hipTime = decoded.hipTime
            self.heelTime = decoded.heelTime
            self.deviceID = decoded.deviceID
        } catch {
            return nil
        }
    }
    
    init(
        id: Int?,
        createdAt: Date, updatedAt: Date? = nil,
        uid: UUID, name: String, height: Float? = nil, weight: Float? = nil,
        occiputTime: Int?, scapulaTime: Int?, elbowTime: Int?, hipTime: Int?, heelTime: Int?,
        deviceID: Int? = nil
    ) {
        if let id {
            self.id = id
        }
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.uid = uid
        self.name = name
        self.height = height
        self.weight = weight
        self.occiputTime = occiputTime
        self.scapulaTime = scapulaTime
        self.elbowTime = elbowTime
        self.hipTime = hipTime
        self.heelTime = heelTime
        self.deviceID = deviceID
    }
}

// Ensure SwiftUI selection/tag uses stable identity only by `id`.
public extension Patient {
    static func == (lhs: Patient, rhs: Patient) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
