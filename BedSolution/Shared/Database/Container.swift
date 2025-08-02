//
//  Container.swift
//  BedSolution
//
//  Created by 이재호 on 8/2/25.
//

import Foundation
import SwiftData

enum DBContainer {
    static let container = try! ModelContainer(
        for: Schema(versionedSchema: DBSchema.self),
        configurations: [ModelConfiguration(isStoredInMemoryOnly: true)]
    )
}
