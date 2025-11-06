//
//  PressureLog.swift
//  BedSolution
//
//  Created by 이재호 on 8/13/25.
//

import Foundation
import Supabase

public enum PostureType: Int, Codable {
    case UKNOWN = 0
    case SITTING = 1
    case LEFT_SIDE = 2
    case RIGHT_SIDE = 3
    case SUPINE = 4
    case PRONE = 5
    case SUPINE_LEFT = 6
    case SUPINE_RIGHT = 7
    
    var title: LocalizedStringResource {
        switch self {
        case .UKNOWN:
            return "미확인"
        case .SITTING:
            return "앉은 자세"
        case .LEFT_SIDE:
            return "좌측와위"
        case .RIGHT_SIDE:
            return "우측와위"
        case .SUPINE:
            return "정자세"
        case .PRONE:
            return "엎드림"
        case .SUPINE_LEFT:
            return "정자세 (좌)"
        case .SUPINE_RIGHT:
            return "정자세 (우)"
        }
    }
}

nonisolated public struct PressureLog: Codable, Hashable, Identifiable {
    public var id: Int = 0
    public var createdAt: Date = Date()
    public var occiputTime: Int = 0
    public var scapulaTime: Int = 0
    public var rightElbowTime: Int = 0
    public var leftElbowTime: Int = 0
    public var hipTime: Int = 0
    public var rightHeelTime: Int = 0
    public var leftHeelTime: Int = 0
    public var dayID: Int = 0
    public var postureType: PostureType = .UKNOWN
    public var needPostureChange: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case occiputTime = "occiput"
        case scapulaTime = "scapula"
        case rightElbowTime = "relbow"
        case leftElbowTime = "lelbow"
        case rightHeelTime = "rheel"
        case leftHeelTime = "lheel"
        case hipTime = "hip"
        case dayID = "day_id"
        case postureType = "posture_type"
        case needPostureChange = "posture_change_required"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.createdAt = try container.decode(Date.self, forKey: .createdAt)
        self.occiputTime = try container.decode(Int.self, forKey: .occiputTime)
        self.scapulaTime = try container.decode(Int.self, forKey: .scapulaTime)
        self.rightElbowTime = try container.decode(Int.self, forKey: .rightElbowTime)
        self.leftElbowTime = try container.decode(Int.self, forKey: .leftElbowTime)
        self.rightHeelTime = try container.decode(Int.self, forKey: .rightHeelTime)
        self.leftHeelTime = try container.decode(Int.self, forKey: .leftHeelTime)
        self.hipTime = try container.decode(Int.self, forKey: .hipTime)
        self.dayID = try container.decode(Int.self, forKey: .dayID)
        self.postureType = try container.decodeIfPresent(PostureType.self, forKey: .postureType) ?? .UKNOWN
        self.needPostureChange = try container.decode(Bool.self, forKey: .needPostureChange)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(occiputTime, forKey: .occiputTime)
        try container.encode(scapulaTime, forKey: .scapulaTime)
        try container.encode(rightElbowTime, forKey: .rightElbowTime)
        try container.encode(leftElbowTime, forKey: .leftElbowTime)
        try container.encode(rightHeelTime, forKey: .rightHeelTime)
        try container.encode(leftHeelTime, forKey: .leftHeelTime)
        try container.encode(hipTime, forKey: .hipTime)
        try container.encode(dayID, forKey: .dayID)
        try container.encode(postureType, forKey: .postureType)
        try container.encode(needPostureChange, forKey: .needPostureChange)
    }
    
    init() {}
    
    init?(row: [String: AnyJSON]) {
        do {
            let decoded = try SupabaseCoding.decode(PressureLog.self, from: row)
            self.id = decoded.id
            self.createdAt = decoded.createdAt
            self.occiputTime = decoded.occiputTime
            self.scapulaTime = decoded.scapulaTime
            self.rightElbowTime = decoded.rightElbowTime
            self.leftElbowTime = decoded.leftElbowTime
            self.rightHeelTime = decoded.rightHeelTime
            self.leftHeelTime = decoded.leftHeelTime
            self.hipTime = decoded.hipTime
            self.dayID = decoded.dayID
            self.postureType = decoded.postureType
            self.needPostureChange = decoded.needPostureChange
        } catch {
            return nil
        }
    }
    
    init(id: Int, createdAt: Date, occiputTime: Int, scapulaTime: Int, rightElbowTime: Int, leftElbowTime: Int, rightHeelTime: Int, leftHeelTime: Int, hipTime: Int, dayID: Int, postureType: PostureType = .UKNOWN, needPostureChange: Bool = false) {
        self.id = id
        self.createdAt = createdAt
        self.occiputTime = occiputTime
        self.scapulaTime = scapulaTime
        self.rightElbowTime = rightElbowTime
        self.leftElbowTime = leftElbowTime
        self.rightHeelTime = rightHeelTime
        self.leftHeelTime = leftHeelTime
        self.hipTime = hipTime
        self.dayID = dayID
        self.postureType = postureType
        self.needPostureChange = needPostureChange
    }
}

