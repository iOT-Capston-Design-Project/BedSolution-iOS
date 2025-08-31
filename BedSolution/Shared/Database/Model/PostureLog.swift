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
    public var patientID: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case memo
        case imgURL = "img_url"
        case dayID = "day_id"
        case patientID = "patient_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.memo = try container.decodeIfPresent(String.self, forKey: .memo)
        self.imgURL = try container.decodeIfPresent(String.self, forKey: .imgURL)
        self.dayID = try container.decode(Int.self, forKey: .dayID)
        self.patientID = try container.decode(Int.self, forKey: .patientID)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(memo, forKey: .memo)
        try container.encodeIfPresent(imgURL, forKey: .imgURL)
        try container.encode(dayID, forKey: .dayID)
        try container.encode(patientID, forKey: .patientID)
    }
    
    init(id: Int, createdAt: Date, memo: String? = nil, imgURL: String? = nil, dayID: Int, patientID: Int) {
        self.id = id
        self.createdAt = createdAt
        self.memo = memo
        self.imgURL = imgURL
        self.dayID = dayID
        self.patientID = patientID
    }
    
    init?(row: [String: AnyJSON]) {
        do {
            let decoded = try SupabaseCoding.decode(PostureLog.self, from: row)
            self.id = decoded.id
            self.createdAt = decoded.createdAt
            self.memo = decoded.memo
            self.imgURL = decoded.imgURL
            self.dayID = decoded.dayID
            self.patientID = decoded.patientID
        } catch {
            return nil
        }
    }
}
