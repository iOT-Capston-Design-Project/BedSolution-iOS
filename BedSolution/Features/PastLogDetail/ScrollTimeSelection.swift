//
//  ScrollTimeSelection.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//


import SwiftUI

struct ScrollTimeSelection: View {
    @Environment(\.theme) private var theme
    @Binding var selection: PressureLog?
    var pressureLogs: [PressureLog]
    
    var body: some View {
        HStack(spacing: 2) {
            Text("시간 선택")
                .textStyle(theme.textTheme.emphasizedLabelLarge)
                .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    ForEach(pressureLogs) { log in
                        Text(log.createdAt, format: .dateTime.hour().minute())
                            .textStyle(
                                selection == log ? theme.textTheme.emphasizedLabelLarge: theme.textTheme.labelLarge
                            )
                            .foregroundColorSet(selection == log ? theme.colorTheme.onSecondaryContainer: theme.colorTheme.onSurface)
                            .padding(EdgeInsets(top: 5, leading: 12, bottom: 5, trailing: 12))
                            .frame(height: 35)
                            .backgroundColorSet(selection == log ? theme.colorTheme.secondaryContainer: theme.colorTheme.surfaceContainerHigh, in: Capsule())
                            .onTapGesture {
                                selection = log
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 16)
            .scrollIndicators(.never)
            .frame(height: 40)
            .animation(.default, value: selection)
        }
    }
}

#Preview {
    @Previewable @State var selection: PressureLog?
    ScrollTimeSelection(
        selection: $selection,
        pressureLogs: [
            PressureLog(
                id: 1,
                createdAt: Date(),
                occiput: 85,
                scapula: 60,
                elbow: 40,
                heel: 95,
                hip: 50,
                deviceID: 101
            ),
            PressureLog(
                id: 2,
                createdAt: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!,
                occiput: 70,
                scapula: 55,
                elbow: 45,
                heel: 88,
                hip: 60,
                deviceID: 101
            ),
            PressureLog(
                id: 3,
                createdAt: Calendar.current.date(byAdding: .hour, value: 1, to: Date())!,
                occiput: 65,
                scapula: 50,
                elbow: 42,
                heel: 80,
                hip: 58,
                deviceID: 102
            )
        ]
    )
}
