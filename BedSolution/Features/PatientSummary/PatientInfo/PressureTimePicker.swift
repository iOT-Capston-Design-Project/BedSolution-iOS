//
//  PressureTimePicker.swift
//  BedSolution
//
//  Created by 이재호 on 9/19/25.
//

import SwiftUI

struct PressureTimePicker: View {
    @Environment(\.theme) private var theme
    @Binding var time: Int?
    private let availableTimes = [
        10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115
    ]
    
    var body: some View {
        VStack(spacing: 5) {
            Picker("", selection: $time) {
                Text("기본 설정").tag(nil as Int?)
                ForEach(availableTimes, id: \.self) {
                    Text(TimeFormatter.formattedDuration(from: $0)).tag($0 as Int?)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            .frame(height: 150)
            if let time {
                Text("\(TimeFormatter.formattedDuration(from: time)) 이상 압력 지속시 알림이 울립니다.")
                    .textStyle(theme.textTheme.labelLarge)
                    .foregroundColorSet(theme.colorTheme.primary)
                    .contentTransition(.numericText(value: Double(time)))
            }
        }
        .animation(.default, value: time)
    }
}

#Preview {
    @Previewable @State var time: Int? = 60
    PressureTimePicker(time: $time)
}
