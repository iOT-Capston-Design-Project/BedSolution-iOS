//
//  PatientSummaryView.swift
//  BedSolution
//
//  Created by 이재호 on 8/15/25.
//

import SwiftUI
import TipKit

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
    enum SheetType: Identifiable {
        case addPosture
        
        var id: Int { hashValue }
    }
    @Environment(\.theme) private var theme
    @Environment(AuthService.self) private var auth
    @State private var patientInfoController = PatientInfoController()
    @State private var showHeatmap = false
    @State private var selectedTab = TabItems.summary
    @State private var sheetType: SheetType? = nil
    private let tabHeight: CGFloat = 45
    let patientId: Int
    
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
                    .environment(patientInfoController)
            case .pastLogs:
                PastLogs()
                    .transition(.blurReplace)
                    .environment(patientInfoController)
            case .patient:
                PatientInfo(controller: patientInfoController)
                    .transition(.blurReplace)
            }
        }
        .backgroundColorSet(theme.colorTheme.surface)
        .allowsHitTesting(!showHeatmap)
        .interactiveDismissDisabled(showHeatmap)
        .navigationBarBackButtonHidden(showHeatmap)
        .overlay {
            if showHeatmap {
                Rectangle()
                    .foregroundStyle(.thinMaterial)
                    .ignoresSafeArea()
                    .transition(.opacity)
                HeatmapViewer(deviceID: patientInfoController.deviceID)
                    .transition(.scale)
            }
        }
        .navigationTitle(Text(showHeatmap ? "\(patientInfoController.name) 압력 분포": patientInfoController.name))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button(action: {
                    withAnimation {
                        showHeatmap.toggle()
                    }
                }) {
                    Label("히트맵", systemImage: showHeatmap ? "xmark": "viewfinder")
                        .contentTransition(.symbolEffect)
                }
                .disabled(patientInfoController.deviceID == nil)
            }
        }
        .sheet(item: $sheetType) { type in
            switch type {
            case .addPosture:
                PostureLogEditor()
                    .presentationDetents([.medium])
            }
        }
        .task {
            if let uid = auth.uid { await patientInfoController.initialize(id: patientId, uid: uid) }
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
        PatientSummaryView(patientId: 0)
            .environment(AuthService())
    }
}
