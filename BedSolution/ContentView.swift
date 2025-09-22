//
//  ContentView.swift
//  BedSolution
//
//  Created by 이재호 on 7/18/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.theme) private var theme
    @State private var auth = AuthService()
    @State private var patients = PatientsController()
    @State private var selectedPatient: Patient?
    
    var body: some View {
        ZStack {
            switch auth.state {
            case .loggedIn:
                NavigationSplitView {
                    PatientList(selection: $selectedPatient)
                } detail: {
                    if let selectedPatient {
                        PatientSummaryView(patientId: selectedPatient.id)
                    } else {
                        NoPatientSelectionView()
                    }
                }
                .transition(.opacity)
                .environment(patients)
                .task {
                    await startIfSignedIn()
                }
            case .loggedOut:
                SignUpView()
                    .transition(.opacity)
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .environment(auth)
        .backgroundColorSet(theme.colorTheme.surface)
        .animation(.default, value: auth.state)
    }
    
    private func startIfSignedIn() async {
        guard let uid = auth.uid else { return }
        await patients.refresh(uid: uid)
    }
}

#Preview {
    ContentView()
}
