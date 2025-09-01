//
//  IDGenerator.swift
//  BedSolution
//
//  Created by 이재호 on 9/1/25.
//

import Foundation

struct IDGenerator {
    static func generateInt64(from uuid: UUID) -> Int64 {
        var hasher = Hasher()
        hasher.combine(uuid.uuidString)
        let hashValue = hasher.finalize()
        return Int64(abs(hashValue))
    }
    
    static func generateInt64() -> Int64 {
        return generateInt64(from: UUID())
    }
}
