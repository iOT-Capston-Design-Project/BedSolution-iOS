//
//  Heatmap.swift
//  BedSolution
//
//  Created by 이재호 on 9/18/25.
//

import Foundation
import Supabase

public struct Heatmap: Codable, Hashable, Identifiable {
    public var id: Int = 0
    public var deviceID: Int = 0
    public var sensors: [Int] = []
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case deviceID = "device_id"
        case sensors
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.deviceID = try container.decode(Int.self, forKey: .deviceID)
        self.sensors = try container.decode([Int].self, forKey: .sensors)
    }
    
    init() {}
    
    init?(row: [String: AnyJSON]) {
        do {
            let decoded = try SupabaseCoding.decode(Heatmap.self, from: row)
            self.id = decoded.id
            self.deviceID = decoded.deviceID
            self.sensors = decoded.sensors
        } catch {
            return nil
        }
    }
    
    init(id: Int, deviceID: Int, sensors: [Int]) {
        self.id = id
        self.deviceID = deviceID
        self.sensors = sensors
    }
}
