//
//  PatientWeightEditView.swift
//  BedSolution
//
//  Created by 이재호 on 8/7/25.
//

import SwiftUI

struct PatientWeightEditView: View {
    @Environment(\.theme) private var theme
    @State private var displayedWeight: Int = 0
    @State private var debounceWorkItem: DispatchWorkItem?
    @Binding var weight: Int
    var onNext: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 25) {
                Text("환자명의 몸무게를 입력해주세요")
                    .textStyle(theme.textTheme.emphasizedTitleMedium)
                Text("\(displayedWeight) kg")
                    .textStyle(theme.textTheme.emphasizedDisplaySmall)
                    .contentTransition(.numericText(value: Double(displayedWeight)))
                
                WeightPicker(weight: $weight)
                    .frame(width: 300)
            }
            Spacer()
            Button(action: onNext) {
                Text("다음")
                    .textStyle(theme.textTheme.emphasizedBodyLarge)
                    .frame(width: 250)
            }
            .buttonStyle(type: .emphasized, option: .fiilled, primary: theme.colorTheme.primary, onPrimary: theme.colorTheme.onPrimary)
        }
        .padding(EdgeInsets(top: 0, leading: 25, bottom: 30, trailing: 25))
        .onAppear { displayedWeight = weight }
        .onChange(of: weight) { _, newWeight in
            debounceWorkItem?.cancel()
            let workItem = DispatchWorkItem { 
                withAnimation(.default) { self.displayedWeight = newWeight }
            }
            debounceWorkItem = workItem
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: workItem)
        }
    }
}

#Preview {
    @Previewable @State var weight: Int = 14
    PatientWeightEditView(weight: $weight, onNext: {})
}
