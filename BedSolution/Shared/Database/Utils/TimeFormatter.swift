//
//  TimeFormatter.swift
//  BedSolution
//
//  Created by 이재호 on 9/19/25.
//

import Foundation

enum TimeFormatter {
    static func formattedDuration(minutes: Int) -> String {
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
    
    static func formattedDuration(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds.remainderReportingOverflow(dividingBy: 3600)).partialValue / 60
        let remainingSeconds = (seconds.remainderReportingOverflow(dividingBy: 3600)).partialValue.remainderReportingOverflow(dividingBy: 60).partialValue
        
        var components: [String] = []
        if hours > 0 {
            components.append("\(hours)h")
        }
        if minutes > 0 {
            components.append("\(minutes)m")
        }
        if remainingSeconds > 0 || components.isEmpty {
            components.append("\(remainingSeconds)s")
        }
        
        return components.joined(separator: " ")
    }
}
