//
//  PatientSummaryView.swift
//  BedSolution
//
//  Created by 이재호 on 8/15/25.
//

import SwiftUI

struct PatientSummaryView: View {
    private enum TabItems {
        case summary, pastLogs, patient
        var title: LocalizedStringResource {
            switch self {
            case .summary:
                "현재 상태"
            case .pastLogs:
                "과거 상태 기록"
            case .patient:
                "환자 정보"
            }
        }
    }
    private struct TabBoundKey: PreferenceKey {
        static var defaultValue: Anchor<CGRect>? = nil
        static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
            value = nextValue() ?? value
        }
    }
    @Environment(\.theme) private var theme
    @State private var tabSize: CGFloat = .zero
    @State private var selectedTab = TabItems.summary
    @State private var tabX: CGFloat = .zero
    @State private var addPosture: Bool = false
    @Namespace private var tabbarSpace
    private let tabHeight: CGFloat = 45
    var patient: Patient
    
    var body: some View {
        VStack(spacing: 5) {
            // Tab
            HStack(spacing: 0) {
                tabItem(item: .summary)
                tabItem(item: .pastLogs)
                tabItem(item: .patient)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlayPreferenceValue(TabBoundKey.self) { anchor in
                GeometryReader { proxy in
                    if let anchor {
                        let rect = proxy[anchor]
                        Rectangle()
                            .frame(width: rect.width, height: 3, alignment: .center)
                            .foregroundColorSet(theme.colorTheme.primary)
                            .offset(x: rect.minX, y: proxy.size.height)
                    }
                }
            }
            
            // Content
            switch selectedTab {
            case .summary:
                CurrentPatientState()
                    .transition(.blurReplace)
            case .pastLogs:
                PastLogs()
                    .transition(.blurReplace)
            case .patient:
                PatientInfo()
                    .transition(.blurReplace)
            }
        }
        .backgroundColorSet(theme.colorTheme.surface)
        .toolbar {
            ToolbarItem {
                Button(action: { addPosture.toggle() }) {
                    Label("자세 기록", systemImage: "figure")
                }
            }
        }
        .navigationTitle(Text("환자 이름"))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $addPosture) {
            PostureLogEditor()
                .presentationDetents([.medium])
        }
    }
    
    @ViewBuilder
    private func tabItem(item: TabItems) -> some View {
        let padding = EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        Text(item.title)
            .textStyle(theme.textTheme.emphasizedTitleMedium)
            .foregroundColorSet(item == selectedTab ? theme.colorTheme.primary: theme.colorTheme.onSurfaceVarient)
            .frame(height: tabHeight)
            .padding(padding)
            .backgroundColorSet(theme.colorTheme.surface)
            .containerShape(Rectangle())
            .anchorPreference(key: TabBoundKey.self, value: .bounds) { anchor in
                item == selectedTab ? anchor: nil
            }
            .onTapGesture {
                withAnimation {
                    selectedTab = item
                }
            }
    }
}

#Preview {
    NavigationStack {
        PatientSummaryView(patient: Patient())
    }
}
