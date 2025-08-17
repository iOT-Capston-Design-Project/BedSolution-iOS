//
//  ContentView.swift
//  BedSolution
//
//  Created by 이재호 on 7/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPatient: Patient?
    
    var body: some View {
        NavigationSplitView {
            PatientList(selection: $selectedPatient)
        } detail: {
            if let selectedPatient {
                PatientSummaryView(patient: selectedPatient)
            } else {
                NoPatientSelectionView()
            }
        }
    }
    
}

#Preview {
    ContentView()
}
