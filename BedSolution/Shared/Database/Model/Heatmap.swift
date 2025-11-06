//
//  Heatmap.swift
//  BedSolution
//
//  Created by 이재호 on 9/18/25.
//

import Foundation
import Supabase

/// 브로드캐스팅을 통해 받는 히트맵 구조
public struct Heatmap: Codable, Hashable, Identifiable {
    public let id = UUID()
    public var sensors: [Int] = []

    enum CodingKeys: String, CodingKey {
        case sensors = "values"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let values = try container.decode([Double].self, forKey: .sensors)
        self.sensors = values.map { Int($0.rounded()) }
    }
    
    init() {}
    
    init?(row: [String: AnyJSON]) {
        do {
            let decoded = try SupabaseCoding.decode(Heatmap.self, from: row)
            self.sensors = decoded.sensors
        } catch {
            return nil
        }
    }
    
    init(sensors: [Int]) {
        self.sensors = sensors
    }
}
