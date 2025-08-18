//
//  PatientNameEditView.swift
//  BedSolution
//
//  Created by 이재호 on 8/7/25.
//

import SwiftUI

struct PatientNameEditView: View {
    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool
    @State private var textWidth: CGFloat = 55
    @Binding var name: String
    var onNext: () -> Void
    private let horizontalPadding: CGFloat = 25
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 25) {
                Text("환자명을 입력해주세요")
                    .textStyle(theme.textTheme.emphasizedTitleMedium)
                VStack(spacing: 15) {
                    ZStack {
                        Text(name.isEmpty ? "홍길동": name)
                            .textStyle(theme.textTheme.emphasizedDisplaySmall)
                            .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                            .background {
                                GeometryReader { proxy in
                                    Color.clear
                                        .onAppear { textWidth = proxy.size.width }
                                        .onChange(of: name) { _, _ in textWidth = proxy.size.width }
                                }
                            }
                            .opacity(name.isEmpty ? 0.4: 0)
                        TextField("", text: $name)
                            .labelsHidden()
                            .lineLimit(1)
                            .textStyle(theme.textTheme.emphasizedDisplaySmall)
                            .frame(width: min(max(textWidth, 55), 250), alignment: .leading)
                            .focused($isFocused)
                        
                    }
                    Rectangle()
                        .frame(width: min(textWidth+horizontalPadding, 250), height: 3)
                        .foregroundColorSet(name.isEmpty ? theme.colorTheme.outline: theme.colorTheme.primary)
                        //.animation(.easeIn, value: textWidth)
                }
            }
            Spacer()
            Button(action: onNext) {
                Text("다음")
                    .textStyle(theme.textTheme.emphasizedBodyLarge)
                    .frame(width: 250)
            }
            .buttonStyle(type: .emphasized, option: .fiilled, primary: theme.colorTheme.primary, onPrimary: theme.colorTheme.onPrimary)
            .disabled(name.isEmpty)
        }
        .padding(EdgeInsets(top: 0, leading: 25, bottom: 30, trailing: 25))
        .defaultFocus($isFocused, true)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    @Previewable @State var name: String = ""
    PatientNameEditView(name: $name, onNext: {})
}
