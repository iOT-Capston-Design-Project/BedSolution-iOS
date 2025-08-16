//
//  DayLog.swift
//  BedSolution
//
//  Created by 이재호 on 8/13/25.
//

import Foundation
import Supabase

nonisolated public struct DayLog: Codable, Identifiable {
    public var id: Int = 0
    public var day: Date = .now
    public var accumulatedOcciput: Int = 0
    public var accumulatedScapula: Int = 0
    public var accumulatedElbow: Int = 0
    public var accumulatedHip: Int = 0
    public var accumulatedHeel: Int = 0
    public var patientID: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case day
        case accumulatedOcciput = "accumulated_occiput"
        case accumulatedScapula = "accumulated_scapula"
        case accumulatedElbow = "accumulated_elbow"
        case accumulatedHip = "accumulated_hip"
        case accumulatedHeel = "accumulated_heel"
        case patientID = "patient_id"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.day = try container.decode(Date.self, forKey: .day)
        self.accumulatedOcciput = try container.decode(Int.self, forKey: .accumulatedOcciput)
        self.accumulatedScapula = try container.decode(Int.self, forKey: .accumulatedScapula)
        self.accumulatedElbow = try container.decode(Int.self, forKey: .accumulatedElbow)
        self.accumulatedHip = try container.decode(Int.self, forKey: .accumulatedHip)
        self.accumulatedHeel = try container.decode(Int.self, forKey: .accumulatedHeel)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(day, forKey: .day)
        try container.encode(accumulatedOcciput, forKey: .accumulatedOcciput)
        try container.encode(accumulatedScapula, forKey: .accumulatedScapula)
        try container.encode(accumulatedElbow, forKey: .accumulatedElbow)
        try container.encode(accumulatedHip, forKey: .accumulatedHip)
        try container.encode(accumulatedHeel, forKey: .accumulatedHeel)
        try container.encodeIfPresent(patientID, forKey: .patientID)
    }
    
    init() {}
    
    init(
        id: Int,
        day: Date,
        accumulatedOcciput: Int,
        accumulatedScapula: Int,
        accumulatedElbow: Int,
        accumulatedHip: Int,
        accumulatedHeel: Int,
        patientID: Int
    ) {
        self.id = id
        self.day = day
        self.accumulatedOcciput = accumulatedOcciput
        self.accumulatedScapula = accumulatedScapula
        self.accumulatedElbow = accumulatedElbow
        self.accumulatedHip = accumulatedHip
        self.accumulatedHeel = accumulatedHeel
        self.patientID = patientID
    }
    
    init?(row: [String: AnyJSON]) {
        do {
            let decoded = try SupabaseCoding.decode(DayLog.self, from: row)
            self.id = decoded.id
            self.day = decoded.day
            self.accumulatedOcciput = decoded.accumulatedOcciput
            self.accumulatedScapula = decoded.accumulatedScapula
            self.accumulatedElbow = decoded.accumulatedElbow
            self.accumulatedHip = decoded.accumulatedHip
            self.accumulatedHeel = decoded.accumulatedHeel
            self.patientID = decoded.patientID
        } catch {
            return nil
        }
    }
    
    
}
