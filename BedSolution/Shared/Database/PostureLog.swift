//
//  PostureLog.swift
//  BedSolution
//
//  Created by 이재호 on 8/1/25.
//

import Foundation
import SwiftData

@Model
final class PostureLog: Codable {
    @Attribute(.unique) public var id: Int = 0
    public var createdAt: Date = Date()
    public var memo: String?
    public var imgURL: String?
    
    public var dayLog: DayLog?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case memo
        case imgURL = "img_url"
        case dayID = "day_id"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.memo = try container.decodeIfPresent(String.self, forKey: .memo)
        self.imgURL = try container.decodeIfPresent(String.self, forKey: .imgURL)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(memo, forKey: .memo)
        try container.encodeIfPresent(imgURL, forKey: .imgURL)
        try container.encodeIfPresent(dayLog?.id, forKey: .dayID)
    }
    
    init() {}
}
