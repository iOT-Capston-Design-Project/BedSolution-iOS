//
//  ScrollPicker.swift
//  BedSolution
//
//  Created by 이재호 on 8/7/25.
//

import SwiftUI

struct WeightPicker: View {
    @Environment(\.theme) private var theme
    var minValue: Int = 0
    var maxValue: Int = 200
    @Binding var weight: Int
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 2) {
                ForEach(Array(minValue..<maxValue), id: \.self) { value in
                    VStack(spacing: 4) {
                        Text(String(value))
                            .textStyle(theme.textTheme.labelMedium)
                            .opacity(labelOpacity(value))
                        Capsule()
                            .frame(
                                width: 3,
                                height: barHeight(value)
                            )
                    }
                    .foregroundColorSet(barColorSet(value))
                    .opacity(barOpacity(value))
                    .animation(.default, value: weight)
                    .scrollTransition { effect, phase in
                        effect
                            .opacity(phase.isIdentity ? 1: 0)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.never)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: Binding<Int?>(get: { weight }, set: { weight = $0 ?? 65}), anchor: .center)
        .sensoryFeedback(.increase, trigger: weight)
        .frame(height: 66)
    }
    
    private func labelOpacity(_ value: Int) -> Double {
        if value == weight || value%10 == 0 {
            return 1
        }
        return 0
    }
    
    private func barOpacity(_ value: Int) -> Double {
        if value == weight {
            return 1
        }
        let ratio = CGFloat(abs(value-weight))/CGFloat(maxValue-minValue)
        if ratio < 0.02 {
            return 0.9
        }
        if ratio < 0.04 {
            return 0.5
        }
        if ratio < 0.05 {
            return 0.3
        }
        return 0
    }
    
    private func barHeight(_ value: Int) -> CGFloat {
        if value == weight {
            return 43
        }
        if value%10 == 0 {
            return 37
        }
        if value%5 == 0 {
            return 35
        }
        return 25
    }
    
    private func barColorSet(_ value: Int) -> ColorSet {
        if value == weight {
            return theme.colorTheme.primary
        }
        if value%10 == 0 {
            return theme.colorTheme.onSurfaceVarient
        }
        return theme.colorTheme.outline
    }
}

#Preview {
    @Previewable @State var weight: Int = 50
    WeightPicker(weight: $weight)
}
