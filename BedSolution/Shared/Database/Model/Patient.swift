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
    public var occiputThreshold: Int?
    public var scapulaThreshold: Int?
    public var rightElbowThreshold: Int?
    public var leftElbowThreshold: Int?
    public var hipThreshold: Int?
    public var rightHeelThreshold: Int?
    public var leftHeelThreshold: Int?
    public var deviceID: Int?
    
    
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.createdAt = try Date(try container.decode(String.self, forKey: .createdAt), strategy: .iso8601)
        let updatedAtStr = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        if let updatedAtStr {
            self.updatedAt = try Date(updatedAtStr, strategy: .iso8601)
        }
        self.uid = try container.decode(UUID.self, forKey: .uid)
        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decodeIfPresent(Float.self, forKey: .height)
        self.weight = try container.decodeIfPresent(Float.self, forKey: .weight)
        self.occiputThreshold = try container.decodeIfPresent(Int.self, forKey: .occiputThreshold)
        self.scapulaThreshold = try container.decodeIfPresent(Int.self, forKey: .scapulaThreshold)
        self.rightElbowThreshold = try container.decodeIfPresent(Int.self, forKey: .rightElbowThreshold)
        self.leftElbowThreshold = try container.decodeIfPresent(Int.self, forKey: .leftElbowThreshold)
        self.hipThreshold = try container.decodeIfPresent(Int.self, forKey: .hipThreshold)
        self.rightHeelThreshold = try container.decodeIfPresent(Int.self, forKey: .rightHeelThreshold)
        self.leftHeelThreshold = try container.decodeIfPresent(Int.self, forKey: .leftHeelThreshold)
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
        try container.encodeIfPresent(occiputThreshold, forKey: .occiputThreshold)
        try container.encodeIfPresent(scapulaThreshold, forKey: .scapulaThreshold)
        try container.encodeIfPresent(rightElbowThreshold, forKey: .rightElbowThreshold)
        try container.encodeIfPresent(leftElbowThreshold, forKey: .leftElbowThreshold)
        try container.encodeIfPresent(hipThreshold, forKey: .hipThreshold)
        try container.encodeIfPresent(rightHeelThreshold, forKey: .rightHeelThreshold)
        try container.encodeIfPresent(leftHeelThreshold, forKey: .leftHeelThreshold)
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
            self.occiputThreshold = decoded.occiputThreshold
            self.scapulaThreshold = decoded.scapulaThreshold
            self.rightElbowThreshold = decoded.rightElbowThreshold
            self.leftElbowThreshold = decoded.leftElbowThreshold
            self.hipThreshold = decoded.hipThreshold
            self.rightHeelThreshold = decoded.rightHeelThreshold
            self.leftHeelThreshold = decoded.leftHeelThreshold
            self.deviceID = decoded.deviceID
        } catch {
            return nil
        }
    }
    
    init(
        id: Int?,
        createdAt: Date,
        updatedAt: Date? = nil,
        uid: UUID,
        name: String,
        height: Float? = nil, weight: Float? = nil,
        occiputThreshold: Int?,
        scapulaThreshold: Int?,
        rightElbowThreshold: Int?,
        leftElbowThreshold: Int?,
        hipThreshold: Int?,
        rightHeelThreshold: Int?,
        leftHeelThreshold: Int?,
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
        self.occiputThreshold = occiputThreshold
        self.scapulaThreshold = scapulaThreshold
        self.rightElbowThreshold = rightElbowThreshold
        self.leftElbowThreshold = leftElbowThreshold
        self.hipThreshold = hipThreshold
        self.rightHeelThreshold = rightHeelThreshold
        self.leftHeelThreshold = leftHeelThreshold
        self.deviceID = deviceID
    }
}

// Ensure SwiftUI selection/tag uses stable identity only by `id`.
public extension Patient {
    static func == (lhs: Patient, rhs: Patient) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
