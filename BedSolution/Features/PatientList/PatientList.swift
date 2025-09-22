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
    @Environment(AuthService.self) private var auth
    @Environment(PatientsController.self) private var patients
    @State private var addPatient = false
    @Binding var selection: Patient?
    private let logger = Logger(label: "PatientList")
    
    var body: some View {
        List(selection: $selection) {
            ForEach(patients.patients) { patient in
                PatientCell(patient: patient)
                    .listRowBackground(RoundedRectangle(cornerRadius: 16).foregroundColorSet(theme.colorTheme.surfaceContainer))
                    .tag(patient)
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive, action: {
                            Task { await patients.delete(patient) }
                        }) {
                            Label("삭제", systemImage: "trash")
                        }
                        .tintColorSet(theme.colorTheme.error)
                    }
            }
        }
        .animation(.default, value: patients.patients)
        .listRowSpacing(6)
        .scrollContentBackground(.hidden)
        .backgroundColorSet(theme.colorTheme.surface)
        .refreshable { await refresh() }
        .overlay {
            if patients.patients.isEmpty {
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
        .sheet(isPresented: $addPatient) {
            NavigationStack {
                PatientRegisterView()
            }
            .presentationDetents([.large])
            .onDisappear {
                Task { await refresh() }
            }
        }
    }
    
    private func refresh() async {
        guard let uid = auth.uid else { return }
        await patients.refresh(uid: uid)
    }
}

#Preview {
    @Previewable @State var selected: Patient?
    NavigationStack {
        PatientList(selection: $selected)
            .environment(AuthService())
    }
}
