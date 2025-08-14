//
//  SupabaseCoding.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import Foundation
import Supabase

enum SupabaseCoding {
    nonisolated static func decode<T: Decodable>(_ type: T.Type, from row: [String: AnyJSON]) throws -> T {
        let rawRow = row.mapValues { $0.rawValue }
        let data = try JSONSerialization.data(withJSONObject: rawRow, options: [])
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
