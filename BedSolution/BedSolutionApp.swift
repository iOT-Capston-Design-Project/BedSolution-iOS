//
//  BedSolutionApp.swift
//  BedSolution
//
//  Created by 이재호 on 7/18/25.
//

import SwiftUI
import SwiftData

@main
struct BedSolutionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DBContainer.container)
    }
}
