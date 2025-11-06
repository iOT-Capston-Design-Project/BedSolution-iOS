//
//  DayLog.swift
//  BedSolution
//
//  Created by 이재호 on 8/13/25.
//

import Foundation
import Supabase

nonisolated public struct DayLog: Codable, Identifiable, Hashable {
    public var id: Int = 0
    public var day: Date = .now
    public var totalOcciputTime: Int = 0
    public var totalScapulaTime: Int = 0
    public var totalRightElbowTime: Int = 0
    public var totalLeftElbowTime: Int = 0
    public var totalHipTime: Int = 0
    public var totalRightHeelTime: Int = 0
    public var totalLeftHeelTime: Int = 0
    public var deviceID: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case day
        case totalOcciputTime = "total_occiput"
        case totalScapulaTime = "total_scapula"
        case totalRightElbowTime = "total_relbow"
        case totalLeftElbowTime = "total_lelbow"
        case totalHipTime = "total_hip"
        case totalRightHeelTime = "total_rheel"
        case totalLeftHeelTime = "total_lheel"
        case deviceID = "device_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        // day(date) comes as "yyyy-MM-dd" from DB
        if let dayString = try? container.decode(String.self, forKey: .day) {
            if let d = SupabaseService.shared.dateOnlyFormatter.date(from: dayString) {
                self.day = d
            } else {
                throw DecodingError.dataCorruptedError(forKey: .day, in: container, debugDescription: "Invalid date-only format")
            }
        } else {
            // Fallback to decoder's strategy
            self.day = try container.decode(Date.self, forKey: .day)
        }
        self.totalOcciputTime = try container.decode(Int.self, forKey: .totalOcciputTime)
        self.totalScapulaTime = try container.decode(Int.self, forKey: .totalScapulaTime)
        self.totalRightElbowTime = try container.decode(Int.self, forKey: .totalRightElbowTime)
        self.totalLeftElbowTime = try container.decode(Int.self, forKey: .totalLeftElbowTime)
        self.totalHipTime = try container.decode(Int.self, forKey: .totalHipTime)
        self.totalRightHeelTime = try container.decode(Int.self, forKey: .totalRightHeelTime)
        self.totalLeftHeelTime = try container.decode(Int.self, forKey: .totalLeftHeelTime)
        self.deviceID = try container.decode(Int.self, forKey: .deviceID)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        // Encode as date-only string (server baseline UTC)
        let dayStr = SupabaseService.shared.formatDateOnly(day)
        try container.encode(dayStr, forKey: .day)
        try container.encode(totalOcciputTime, forKey: .totalOcciputTime)
        try container.encode(totalScapulaTime, forKey: .totalScapulaTime)
        try container.encode(totalRightElbowTime, forKey: .totalRightElbowTime)
        try container.encode(totalLeftElbowTime, forKey: .totalLeftElbowTime)
        try container.encode(totalHipTime, forKey: .totalHipTime)
        try container.encode(totalRightHeelTime, forKey: .totalRightHeelTime)
        try container.encode(totalLeftHeelTime, forKey: .totalLeftHeelTime)
        try container.encode(deviceID, forKey: .deviceID)
    }
    
    init() {}
    
    init(
        id: Int,
        day: Date,
        totalOcciputTime: Int,
        totalScapulaTime: Int,
        totalRightElbowTime: Int,
        totalLeftElbowTime: Int,
        totalHipTime: Int,
        totalRightHeelTime: Int,
        totalLeftHeelTime: Int,
        deviceID: Int
    ) {
        self.id = id
        self.day = day
        self.totalOcciputTime = totalOcciputTime
        self.totalScapulaTime = totalScapulaTime
        self.totalRightElbowTime = totalRightElbowTime
        self.totalLeftElbowTime = totalLeftElbowTime
        self.totalHipTime = totalHipTime
        self.totalRightHeelTime = totalRightHeelTime
        self.totalLeftHeelTime = totalLeftHeelTime
        self.deviceID = deviceID
    }
    
    init?(row: [String: AnyJSON]) {
        do {
            let decoded = try SupabaseCoding.decode(DayLog.self, from: row)
            self.id = decoded.id
            self.day = decoded.day
            self.totalOcciputTime = decoded.totalOcciputTime
            self.totalScapulaTime = decoded.totalScapulaTime
            self.totalRightElbowTime = decoded.totalRightElbowTime
            self.totalLeftElbowTime = decoded.totalLeftElbowTime
            self.totalHipTime = decoded.totalHipTime
            self.totalRightHeelTime = decoded.totalRightHeelTime
            self.totalLeftHeelTime = decoded.totalLeftHeelTime
            self.deviceID = decoded.deviceID
        } catch {
            return nil
        }
    }
    
}
