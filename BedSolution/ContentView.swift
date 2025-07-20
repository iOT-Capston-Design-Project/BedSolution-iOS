//
//  ContentView.swift
//  BedSolution
//
//  Created by 이재호 on 7/18/25.
//

import SwiftUI
import BedResource

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
                .foregroundColor(Theme.light.colors.primary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
