//
//  PatientList.swift
//  BedSolution
//
//  Created by 이재호 on 8/16/25.
//

import SwiftUI

struct PatientList: View {
    @Environment(\.theme) private var theme
    @State private var patients: [Patient] = (0..<10).map { id in
        Patient(
            id: id,
            createdAt: Calendar.current.date(byAdding: .day, value: -id, to: .now)!,
            updatedAt: nil,
            uid: UUID(),
            name: "Patient \(id)",
            height: 170.0,
            weight: 65.0,
            cautionOcciput: false,
            cautionScapula: false,
            cautionElbow: false,
            cautionHip: false,
            cautionHeel: false
        )
    }
    @Binding var selection: Patient?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(patients) { patient in
                PatientCell(patient: patient)
                    .listRowBackground(RoundedRectangle(cornerRadius: 16).foregroundColorSet(theme.colorTheme.surfaceContainer))
                    .tag(patient)
                    .swipeActions(allowsFullSwipe: false) {
                        Button(action: {}) {
                            Label("삭제", systemImage: "trash")
                        }
                        .tintColorSet(theme.colorTheme.error)
                    }
            }
        }
        .listRowSpacing(6)
        .scrollContentBackground(.hidden)
        .backgroundColorSet(theme.colorTheme.surface)
        .overlay {
            if patients.isEmpty {
                EmptyPatientView()
                    .transition(.opacity)
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: {}) {
                    Label("환자 추가", systemImage: "plus")
                }
            }
        }
        .navigationTitle(Text("환자 목록"))
    }
}

#Preview {
    @Previewable @State var selected: Patient?
    NavigationStack {
        PatientList(selection: $selected)
    }
}
