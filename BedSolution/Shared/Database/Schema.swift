//
//  Schema.swift
//  BedSolution
//
//  Created by 이재호 on 8/2/25.
//

import Foundation
import SwiftData

enum DBSchema: VersionedSchema {
    static var models: [any PersistentModel.Type] = [DayLog.self, Device.self, Patient.self, PostureLog.self, PressureLog.self]
    static var versionIdentifier: Schema.Version = .init(1, 0, 0)
}
