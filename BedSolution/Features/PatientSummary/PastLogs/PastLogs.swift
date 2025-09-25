//
//  PastLogs.swift
//  BedSolution
//
//  Created by 이재호 on 8/14/25.
//

import SwiftUI

struct PastLogs: View {
    @Environment(\.theme) private var theme
    @Environment(PatientInfoController.self) private var patientInfo
    @State private var controller = PastLogsController()
    // Scroll view position
    @State private var scrollPosition = ScrollPosition(y: 0)
    @State private var rightX: CGFloat = 0
    @State private var selectedLog: DayLog? = nil
    private let rowHeight: CGFloat = 55
    private let headerHeight: CGFloat = 40
    private let columnWidth: CGFloat = 120
    private let columns: [String] = ["뒤통수", "견갑골", "팔꿈치", "엉덩뼈", "발꿈치"]
    
    private var columnDivider: some View {
        Rectangle()
            .frame(width: 1)
            .foregroundColorSet(theme.colorTheme.outline)
            .opacity(rightX > 0 ? 1: 0)
            .animation(.easeOut, value: rightX)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Content
            ScrollView(.vertical) {
                HStack(spacing: 0) {
                    // Left column
                    LazyVStack(spacing: 0) {
                        ForEach(controller.dayLogs) { log in
                            Text(log.day, format: .dateTime.year().month().day())
                                .textStyle(theme.textTheme.emphasizedTitleMedium)
                                .foregroundColorSet(theme.colorTheme.primary)
                                .frame(width: columnWidth, height: rowHeight)
                                .overlay(alignment: .bottom) {
                                    Rectangle().frame(height: 1)
                                        .foregroundColorSet(theme.colorTheme.outline)
                                }
                                .id(log.id)
                                .onTapGesture {
                                    selectedLog = log
                                }
                        }
                    }
                    .frame(width: columnWidth)
                    .backgroundColorSet(rightX > 0 ? theme.colorTheme.surfaceContainerHigh: theme.colorTheme.surfaceContainer)
                    .animation(.easeOut, value: rightX)
                    
                    columnDivider
                    
                    // Right columns
                    ScrollView(.horizontal) {
                        LazyVStack(spacing: 0) {
                            ForEach(controller.dayLogs) { log in
                                HStack(spacing: 0) { // Columns
                                    columnContent(accumulatedPressure: log.accumulatedOcciput)
                                    columnContent(accumulatedPressure: log.accumulatedScapula)
                                    columnContent(accumulatedPressure: log.accumulatedElbow)
                                    columnContent(accumulatedPressure: log.accumulatedHip)
                                    columnContent(accumulatedPressure: log.accumulatedHeel)
                                }
                                .overlay(alignment: .bottom) {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColorSet(theme.colorTheme.outline)
                                }
                                .onTapGesture {
                                    selectedLog = log
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
                await controller.refresh(deviceID: patientInfo.deviceID)
            }
            
            // Header
            HStack(spacing: 0) {
                Text("날짜")
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
        .overlay {
            if controller.dayLogs.isEmpty {
                Text("과거 기록이 없습니다.")
                    .textStyle(theme.textTheme.emphasizedLabelLarge)
                    .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
            }
        }
        .safeAreaInset(edge: .bottom) {
            if controller.isFailed {
                Button(action: {
                    Task { await controller.refresh(deviceID: patientInfo.deviceID)  }
                }) {
                    Label("다시 불러오기", systemImage: "arrow.clockwise")
                        .textStyle(theme.textTheme.emphasizedLabelLarge)
                }
                .buttonStyle(type: .chip, option: .fiilled, primary: theme.colorTheme.secondary, onPrimary: theme.colorTheme.onSecondary)
            }
        }
        .onChange(of: patientInfo.deviceID) { _, deviceID in
            Task {
                await controller.refresh(deviceID: deviceID)
            }
        }
        .task {
            await controller.refresh(deviceID: patientInfo.deviceID)
        }
        .sheet(item: $selectedLog) { log in
            PatientLogDetailView(deviceID: log.deviceID, id: log.id)
        }
    }
    
    @ViewBuilder
    private func columnContent(accumulatedPressure: Int) -> some View {
        Text(TimeFormatter.formattedDuration(from: accumulatedPressure))
            .textStyle(theme.textTheme.bodyLarge)
            .frame(width: columnWidth, height: rowHeight)
            .backgroundColorSet(theme.colorTheme.surfaceContainer)
    }
}

#Preview {
    PastLogs()
        .environment(PatientInfoController())
}
