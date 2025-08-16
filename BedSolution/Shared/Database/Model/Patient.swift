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
    public var cautionOcciput: Bool = false
    public var cautionScapula: Bool = false
    public var cautionElbow: Bool = false
    public var cautionHip: Bool = false
    public var cautionHeel: Bool = false
    
    
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        self.uid = try container.decode(UUID.self, forKey: .uid)
        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decodeIfPresent(Float.self, forKey: .height)
        self.weight = try container.decodeIfPresent(Float.self, forKey: .weight)
        self.cautionOcciput = try container.decode(Bool.self, forKey: .cautionOcciput)
        self.cautionScapula = try container.decode(Bool.self, forKey: .cautionScapula)
        self.cautionElbow = try container.decode(Bool.self, forKey: .cautionElbow)
        self.cautionHip = try container.decode(Bool.self, forKey: .cautionHip)
        self.cautionHeel = try container.decode(Bool.self, forKey: .cautionHeel)
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
        try container.encode(cautionOcciput, forKey: .cautionOcciput)
        try container.encode(cautionScapula, forKey: .cautionScapula)
        try container.encode(cautionElbow, forKey: .cautionElbow)
        try container.encode(cautionHip, forKey: .cautionHip)
        try container.encode(cautionHeel, forKey: .cautionHeel)
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
            self.cautionOcciput = decoded.cautionOcciput
            self.cautionScapula = decoded.cautionScapula
            self.cautionElbow = decoded.cautionElbow
            self.cautionHip = decoded.cautionHip
            self.cautionHeel = decoded.cautionHeel
        } catch {
            return nil
        }
    }
    
    init(
        id: Int?,
        createdAt: Date, updatedAt: Date? = nil,
        uid: UUID, name: String, height: Float? = nil, weight: Float? = nil,
        cautionOcciput: Bool, cautionScapula: Bool, cautionElbow: Bool, cautionHip: Bool, cautionHeel: Bool
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
        self.cautionOcciput = cautionOcciput
        self.cautionScapula = cautionScapula
        self.cautionElbow = cautionElbow
        self.cautionHip = cautionHip
        self.cautionHeel = cautionHeel
    }
}
