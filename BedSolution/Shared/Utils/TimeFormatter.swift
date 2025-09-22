//
//  TimeFormatter.swift
//  BedSolution
//
//  Created by 이재호 on 9/19/25.
//

import Foundation

enum TimeFormatter {
    static func formattedDuration(from minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        var components: [String] = []
        if hours > 0 {
            components.append("\(hours)h")
        }
        if remainingMinutes > 0 || components.isEmpty {
            components.append("\(remainingMinutes)m")
        }

        return components.joined(separator: " ")
    }
}
