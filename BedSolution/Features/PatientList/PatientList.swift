//
//  PatientList.swift
//  BedSolution
//
//  Created by 이재호 on 8/16/25.
//

import SwiftUI
import Logging

struct PatientList: View {
    @Environment(\.theme) private var theme
    @State private var patients: [Patient] = []
    @State private var addPatient = false
    @Binding var selection: Patient?
    private let logger = Logger(label: "PatientList")
    
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
        .refreshable {
            await fetchPatients()
        }
        .overlay {
            if patients.isEmpty {
                EmptyPatientView()
                    .transition(.opacity)
            }
        }
        .toolbar {
            ToolbarItem {
                Button(action: { addPatient.toggle() }) {
                    Label("환자 추가", systemImage: "plus")
                }
            }
        }
        .navigationTitle(Text("환자 목록"))
        .task {
            await fetchPatients()
        }
        .sheet(isPresented: $addPatient) {
            NavigationStack {
                PatientRegisterView()
            }
            .presentationDetents([.large])
        }
    }
    
    private func fetchPatients() async {
        guard let uid = AuthController.shared.getUID() else {
            logger.info("No UID")
            return
        }
        let repo = PatientRepository()
        do {
            patients = try await repo.list(filter: .init(uid: uid), limit: nil)
            logger.info("Fetch patients successfully")
        } catch {
            logger.error("Fail to fetch patients: \(error.localizedDescription)")
        }
    }
}

#Preview {
    @Previewable @State var selected: Patient?
    NavigationStack {
        PatientList(selection: $selected)
    }
}
