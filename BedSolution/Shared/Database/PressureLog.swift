//
//  PressureLog.swift
//  BedSolution
//
//  Created by 이재호 on 8/1/25.
//

import Foundation
import SwiftData

@Model
final class PressureLog: Codable {
    @Attribute(.unique) public var id: Int = 0
    public var createdAt: Date = Date()
    public var occiput: Int = 0
    public var scapula: Int = 0
    public var elbow: Int = 0
    public var heel: Int = 0
    public var hip: Int = 0
    
    public var device: Device?
    public var dayLog: DayLog?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case occiput
        case scapula
        case elbow
        case heel
        case hip
        case deviceID = "device_id"
        case dayID = "day_id"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.occiput = try container.decode(Int.self, forKey: .occiput)
        self.scapula = try container.decode(Int.self, forKey: .scapula)
        self.elbow = try container.decode(Int.self, forKey: .elbow)
        self.heel = try container.decode(Int.self, forKey: .heel)
        self.hip = try container.decode(Int.self, forKey: .hip)
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
        try container.encodeIfPresent(device?.id, forKey: .deviceID)
        try container.encodeIfPresent(dayLog?.id, forKey: .dayID)
    }
    
    init() {}
}
