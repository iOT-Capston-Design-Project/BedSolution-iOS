//
//  PatientList.swift
//  BedSolution
//
//  Created by 이재호 on 8/16/25.
//

import SwiftUI
import Logging

private enum PatientListSheetTypes: Identifiable {
  case addPatient
  case showPatient(Patient)
  
  var id: Int {
    switch self {
    case .addPatient:
      return -1
    case .showPatient(let patient):
      return patient.id
    }
  }
}

struct PatientList: View {
    @Environment(\.theme) private var theme
    @Environment(AuthService.self) private var auth
    @State private var patients = PatientsController()
  @State private var sheet: PatientListSheetTypes? = nil
    private let logger = Logger(label: "PatientList")
    
    var body: some View {
      NavigationStack {
        List {
            ForEach(patients.patients) { patient in
              PatientCell(patient: patient)
                .onTapGesture {
                  sheet = .showPatient(patient)
                }
                .listRowBackground(RoundedRectangle(cornerRadius: 16)
                  .foregroundColorSet(theme.colorTheme.surfaceContainer))
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
              Button(action: { sheet = .addPatient }) {
                    Label("환자 추가", systemImage: "plus")
                }
            }
          ToolbarItem(placement: .cancellationAction) {
                Menu {
                    Button(role: .destructive, action: {
                        Task { await auth.signout() }
                    }) {
                        Label("로그아웃", systemImage: "lock.open")
                    }
                } label: {
                    Label("설정", systemImage: "gearshape")
                }
            }
        }
        .navigationTitle(Text("환자 목록"))
      }
      .task {
        guard let uid = auth.uid else { return }
        await patients.refresh(uid: uid)
      }
      .sheet(item: $sheet) { sheet in
        switch sheet {
        case .addPatient:
          NavigationStack {
              PatientRegisterView()
          }
          .presentationDetents([.large])
          .onDisappear {
              Task { await refresh() }
          }
        case .showPatient(let patient):
          PatientDetailView(patient: patient)
        }
      }
    }
    
    private func refresh() async {
        guard let uid = auth.uid else { return }
        await patients.refresh(uid: uid)
    }
}

#Preview {
    NavigationStack {
        PatientList()
            .environment(AuthService())
    }
    .environment(PatientsController())
}
