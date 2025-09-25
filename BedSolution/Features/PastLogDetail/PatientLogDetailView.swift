//
//  PatientLogDetailView.swift
//  BedSolution
//
//  Created by 이재호 on 8/17/25.
//

import SwiftUI

struct PatientLogDetailView: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    @State private var dayLog = DayLogController()
    var deviceID: Int
    var id: Int
    
    // Scroll view position
    @State private var scrollPosition = ScrollPosition(y: 0)
    @State private var rightX: CGFloat = 0
    private let rowHeight: CGFloat = 55
    private let headerHeight: CGFloat = 40
    private let columnWidth: CGFloat = 120
    private let columns: [String] = ["자세", "뒤통수", "견갑골", "팔꿈치", "엉덩뼈", "발꿈치"]
    
    private var columnDivider: some View {
        Rectangle()
            .frame(width: 1)
            .foregroundColorSet(theme.colorTheme.outline)
            .opacity(rightX > 0 ? 1: 0)
            .animation(.easeOut, value: rightX)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                // Content
                ScrollView(.vertical) {
                    HStack(spacing: 0) {
                        // Left column
                        LazyVStack(spacing: 0) {
                            ForEach(dayLog.pressureLogs) { log in
                                Text(log.createdAt, format: .dateTime.year(.omitted).month(.omitted).day(.omitted).hour(.twoDigits(amPM: .narrow)).minute().second())
                                    .textStyle(theme.textTheme.emphasizedTitleMedium)
                                    .foregroundColorSet(theme.colorTheme.primary)
                                    .frame(width: columnWidth, height: rowHeight)
                                    .overlay(alignment: .bottom) {
                                        Rectangle().frame(height: 1)
                                            .foregroundColorSet(theme.colorTheme.outline)
                                    }
                                    .id(log.id)
                            }
                        }
                        .frame(width: columnWidth)
                        .backgroundColorSet(rightX > 0 ? theme.colorTheme.surfaceContainerHigh: theme.colorTheme.surfaceContainer)
                        .animation(.easeOut, value: rightX)
                        
                        columnDivider
                        
                        // Right columns
                        ScrollView(.horizontal) {
                            LazyVStack(spacing: 0) {
                                ForEach(dayLog.pressureLogs) { log in
                                    HStack(spacing: 0) { // Columns
                                        columnContent(type: log.postureType)
                                        columnContent(time: log.occiput)
                                        columnContent(time: log.scapula)
                                        columnContent(time: log.elbow)
                                        columnContent(time: log.hip)
                                        columnContent(time: log.heel)
                                    }
                                    .overlay(alignment: .bottom) {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColorSet(theme.colorTheme.outline)
                                    }
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollIndicators(.never)
                        .scrollBounceBehavior(.basedOnSize, axes: [.horizontal])
                        .onScrollGeometryChange(
                            for: CGFloat.self,
                            of: { geo in geo.contentOffset.x },
                            action: { _, newX in
                                rightX = newX
                            }
                        )
                    }
                }
                .scrollIndicators(.never)
                .scrollPosition($scrollPosition)
                .scrollBounceBehavior(.basedOnSize)
                .contentMargins(.top, headerHeight)
                .refreshable {
                    await dayLog.fetch(deviceID: deviceID, id: id)
                }
                
                // Header
                HStack(spacing: 0) {
                    Text("시간")
                        .textStyle(theme.textTheme.labelLarge)
                        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                        .frame(width: columnWidth, height: headerHeight)
                    columnDivider
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                ForEach(columns, id: \.self) { column in
                                    Text(column)
                                        .textStyle(theme.textTheme.labelLarge)
                                        .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                                        .minimumScaleFactor(0.9)
                                        .frame(width: columnWidth, height: headerHeight)
                                }
                            }
                            .frame(width: CGFloat(columns.count)*columnWidth, height: headerHeight, alignment: .leading)
                            .offset(x: -rightX)
                        }
                        .frame(width: proxy.size.width, alignment: .leading)
                        .clipped()
                    }
                }
                .frame(height: headerHeight)
                .backgroundColorSet(theme.colorTheme.surface)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColorSet(theme.colorTheme.outline)
                }
            }
            .navigationTitle(Text(dayLog.day, format: .dateTime.year().month().day()))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button(action: { dismiss() }) {
                        Label("닫기", systemImage: "xmark")
                    }
                }
            }
        }
        .interactiveDismissDisabled()
        .overlay {
            if dayLog.state == .fetching {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.thinMaterial)
                        .ignoresSafeArea()
                    VStack {
                        ProgressView()
                        Text("기록 불러오는 중")
                            .textStyle(theme.textTheme.labelLarge)
                    }
                    .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
                }
            }
        }
        .task {
            await dayLog.fetch(deviceID: deviceID, id: id)
        }
    }
    
    @ViewBuilder
    private func columnContent(time: Int) -> some View {
        Text(TimeFormatter.formattedDuration(from: time/60))
            .textStyle(theme.textTheme.bodyLarge)
            .frame(width: columnWidth, height: rowHeight)
            .backgroundColorSet(theme.colorTheme.surfaceContainer)
    }
    
    @ViewBuilder
    private func columnContent(type: PostureType) -> some View {
        Text(type.title)
            .textStyle(theme.textTheme.bodyLarge)
            .frame(width: columnWidth, height: rowHeight)
            .backgroundColorSet(theme.colorTheme.surfaceContainer)
    }
    
}

#Preview {
    PatientLogDetailView(deviceID: 333712847, id: 20250923)
}
