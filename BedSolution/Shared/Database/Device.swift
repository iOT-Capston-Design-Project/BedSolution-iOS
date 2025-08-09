//
//  Device.swift
//  BedSolution
//
//  Created by 이재호 on 8/1/25.
//

import Foundation
import SwiftData

@Model
final class Device: Codable {
    @Attribute(.unique) public var id: Int = 0
    public var createdAt: Date = Date()
    
    @Relationship(deleteRule: .nullify, inverse: \PressureLog.device)
    public var pressureLogs: [PressureLog] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
    }
    
    init() {}
}
