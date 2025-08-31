//
//  PressureLog.swift
//  BedSolution
//
//  Created by 이재호 on 8/13/25.
//

import Foundation
import Supabase

public enum PostureType: Int, Codable {
    case UKNOWN = 0
    case SITTING = 1
    case LEFT_SIDE = 2
    case RIGHT_SIDE = 3
    case SUPINE = 4
    case PRONE = 5
}

nonisolated public struct PressureLog: Codable, Hashable, Identifiable {
    public var id: Int = 0
    public var createdAt: Date = Date()
    public var occiput: Int = 0
    public var scapula: Int = 0
    public var elbow: Int = 0
    public var heel: Int = 0
    public var hip: Int = 0
    public var dayID: Int = 0
    public var postureType: PostureType = .UKNOWN
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case occiput
        case scapula
        case elbow
        case heel
        case hip
        case dayID = "day_id"
        case postureType = "posture_type"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.occiput = try container.decode(Int.self, forKey: .occiput)
        self.scapula = try container.decode(Int.self, forKey: .scapula)
        self.elbow = try container.decode(Int.self, forKey: .elbow)
        self.heel = try container.decode(Int.self, forKey: .heel)
        self.hip = try container.decode(Int.self, forKey: .hip)
        self.dayID = try container.decode(Int.self, forKey: .dayID)
        self.postureType = try container.decodeIfPresent(PostureType.self, forKey: .postureType) ?? .UKNOWN
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(occiput, forKey: .occiput)
        try container.encode(scapula, forKey: .scapula)
        try container.encode(elbow, forKey: .elbow)
        try container.encode(heel, forKey: .heel)
        try container.encode(hip, forKey: .hip)
        try container.encode(dayID, forKey: .dayID)
        try container.encode(postureType, forKey: .postureType)
    }
    
    init() {}
    
    init?(row: [String: AnyJSON]) {
        do {
            let decoded = try SupabaseCoding.decode(PressureLog.self, from: row)
            self.id = decoded.id
            self.createdAt = decoded.createdAt
            self.occiput = decoded.occiput
            self.scapula = decoded.scapula
            self.elbow = decoded.elbow
            self.heel = decoded.heel
            self.hip = decoded.hip
            self.dayID = decoded.dayID
            self.postureType = decoded.postureType
        } catch {
            return nil
        }
    }
    
    init(id: Int, createdAt: Date, occiput: Int, scapula: Int, elbow: Int, heel: Int, hip: Int, dayID: Int, postureType: PostureType = .UKNOWN) {
        self.id = id
        self.createdAt = createdAt
        self.occiput = occiput
        self.scapula = scapula
        self.elbow = elbow
        self.heel = heel
        self.hip = hip
        self.dayID = dayID
        self.postureType = postureType
    }
}
