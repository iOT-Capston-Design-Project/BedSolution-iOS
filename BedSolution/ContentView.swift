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
    
    var body: some View {
        ZStack {
            switch auth.state {
            case .loggedIn:
              PatientList()
                .transition(.opacity)
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
}

#Preview {
    ContentView()
}
