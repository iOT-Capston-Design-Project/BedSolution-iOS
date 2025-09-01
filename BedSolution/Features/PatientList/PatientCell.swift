//
//  PatientCell.swift
//  BedSolution
//
//  Created by 이재호 on 8/16/25.
//

import SwiftUI

struct PatientCell: View {
    @Environment(\.theme) private var theme
    @State private var isWarning: Bool = false
    var patient: Patient
    
    var body: some View {
        HStack(spacing: 10) {
            if isWarning {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColorSet(theme.colorTheme.error)
                    .transition(.scale)
            }
            VStack(alignment: .leading) {
                Text(patient.name)
                    .textStyle(theme.textTheme.emphasizedTitleMedium)
                    .foregroundColorSet(theme.colorTheme.onSurface)
                Group {
                    Text(patient.createdAt, format: .dateTime.year().month().day()) + Text("에 생성")
                }
                .textStyle(theme.textTheme.labelMedium)
                .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
            }
            Spacer()
        }
        .contentShape(Rectangle())
        .animation(.default, value: isWarning)
    }
}

#Preview {
    PatientCell(patient: Patient(id: 0, createdAt: .now, uid: UUID(), name: "Lee Jaeho", cautionOcciput: true, cautionScapula: false, cautionElbow: true, cautionHip: true, cautionHeel: false))
}
