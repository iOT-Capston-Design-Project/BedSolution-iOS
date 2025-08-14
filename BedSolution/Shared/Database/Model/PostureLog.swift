//
//  PostureLog.swift
//  BedSolution
//
//  Created by 이재호 on 8/13/25.
//

import Foundation
import Supabase

public struct PostureLog: Codable, Identifiable {
    public var id: Int = 0
    public var createdAt: Date = Date()
    public var memo: String?
    public var imgURL: String?
    public var dayID: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case memo
        case imgURL = "img_url"
        case dayID = "day_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.memo = try container.decodeIfPresent(String.self, forKey: .memo)
        self.imgURL = try container.decodeIfPresent(String.self, forKey: .imgURL)
        self.dayID = try container.decode(Int.self, forKey: .dayID)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(memo, forKey: .memo)
        try container.encodeIfPresent(imgURL, forKey: .imgURL)
        try container.encodeIfPresent(dayID, forKey: .dayID)
    }
    
    init(id: Int, memo: String? = nil, imgURL: String? = nil, dayID: Int) {
        self.id = id
        self.createdAt = Date.now
        self.memo = memo
        self.imgURL = imgURL
        self.dayID = dayID
    }
    
    init?(row: [String: AnyJSON]) {
        do {
            let decoded = try SupabaseCoding.decode(PostureLog.self, from: row)
            self.id = decoded.id
            self.createdAt = decoded.createdAt
            self.memo = decoded.memo
            self.imgURL = decoded.imgURL
        } catch {
            return nil
        }
    }
}
