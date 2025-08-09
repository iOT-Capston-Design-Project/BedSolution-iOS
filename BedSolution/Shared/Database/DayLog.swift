//
//  DayLog.swift
//  BedSolution
//
//  Created by 이재호 on 8/1/25.
//

import Foundation
import SwiftData

@Model
final class DayLog: Codable {
    @Attribute(.unique) public var id: Int = 0
    public var accumulatedOcciput: Int = 0
    public var accumulatedScapula: Int = 0
    public var accumulatedElbow: Int = 0
    public var accumulatedHip: Int = 0
    public var accumulatedHeel: Int = 0
    
    public var patient: Patient?
    
    @Relationship(deleteRule: .cascade, inverse: \PostureLog.dayLog)
    public var postureLogs: [PostureLog] = []
    
    @Relationship(deleteRule: .cascade, inverse: \PressureLog.dayLog)
    public var pressureLogs: [PressureLog] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case accumulatedOcciput = "accumulated_occiput"
        case accumulatedScapula = "accumulated_scapula"
        case accumulatedElbow = "accumulated_elbow"
        case accumulatedHip = "accumulated_hip"
        case accumulatedHeel = "accumulated_heel"
        case patientID = "patient_id"
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.accumulatedOcciput = try container.decode(Int.self, forKey: .accumulatedOcciput)
        self.accumulatedScapula = try container.decode(Int.self, forKey: .accumulatedScapula)
        self.accumulatedElbow = try container.decode(Int.self, forKey: .accumulatedElbow)
        self.accumulatedHip = try container.decode(Int.self, forKey: .accumulatedHip)
        self.accumulatedHeel = try container.decode(Int.self, forKey: .accumulatedHeel)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(accumulatedOcciput, forKey: .accumulatedOcciput)
        try container.encode(accumulatedScapula, forKey: .accumulatedScapula)
        try container.encode(accumulatedElbow, forKey: .accumulatedElbow)
        try container.encode(accumulatedHip, forKey: .accumulatedHip)
        try container.encode(accumulatedHeel, forKey: .accumulatedHeel)
        try container.encodeIfPresent(patient?.id, forKey: .patientID)
    }
    
    init() {}
}
