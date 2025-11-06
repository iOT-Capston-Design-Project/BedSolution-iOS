//
//  DayLogsView.swift
//  BedSolution
//
//  Created by 이재호 on 11/3/25.
//

import SwiftUI

struct DayLogsView: View {
  @Environment(\.theme) private var theme
  // MARK: - 테이블을 위한 속성들
  @State private var scrollPosition = ScrollPosition(y: 0)
  @State private var rightX: CGFloat = 0
  private let rowHeight: CGFloat = 55
  private let headerHeight: CGFloat = 40
  private let columnWidth: CGFloat = 120
  private let columns: [String] = [
    "뒤통수", "견갑골", "우측 팔꿈치",
    "좌측 팔꿈치", "엉덩뼈", "우측 발꿈치",
    "좌측 발꿈치"
  ]
  private var columnDivider: some View {
      Rectangle()
          .frame(width: 1)
          .foregroundColorSet(theme.colorTheme.outline)
          .opacity(rightX > 0 ? 1: 0)
          .animation(.easeOut, value: rightX)
  }
  // MARK: - 환자 정보
  @State private var vm = DayLogsViewModel()
  var patient: Patient
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .topLeading) {
        // Content
        ScrollView(.vertical) {
          HStack(spacing: 0) {
            // Left column
            LazyVStack(spacing: 0) {
              ForEach(vm.dayLogs) { log in
                    DayLogDateColumnElement(
                      columnWidth: columnWidth,
                      rowHeight: rowHeight,
                      log: log
                    )
                    .id(log.id)
                }
            }
            .frame(width: columnWidth)
            .backgroundColorSet(
              rightX > 0 ?
              theme.colorTheme.surfaceContainerHigh:
              theme.colorTheme.surfaceContainer
            )
            .animation(.easeOut, value: rightX)
            
            columnDivider
            
            // Right columns
            ScrollView(.horizontal) {
                LazyVStack(spacing: 0) {
                  ForEach(vm.dayLogs) { log in
                    NavigationLink(value: log) {
                      DayLogRow(
                        columnWidth: columnWidth,
                        rowHeight: rowHeight,
                        dayLog: log
                      )
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
          await vm.fetchDayLogs(patient: patient)
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
                    .frame(width: CGFloat(columns.count)*columnWidth, height: headerHeight, alignment:.leading)
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
        
        if let vmError = vm.error {
          VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle.fill")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 35, height: 35)
            Text(errorMessage(vmError))
              .textStyle(theme.textTheme.emphasizedLabelLarge)
          }
          .foregroundColorSet(theme.colorTheme.error)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if vm.dayLogs.isEmpty {
          VStack(spacing: 15) {
            Image(systemName: "tray")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 35, height: 35)
            Text("압력 기록이 없어요.")
              .textStyle(theme.textTheme.emphasizedLabelLarge)
          }
          .foregroundColorSet(theme.colorTheme.onSurfaceVarient)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
      .backgroundColorSet(theme.colorTheme.surface)
      .navigationTitle(Text("과거 기록"))
      .toolbarTitleDisplayMode(.inline)
      .navigationDestination(for: DayLog.self) {
        DayLogDetailView(dayLog: $0)
      }
    }
    .task {
      await vm.fetchDayLogs(patient: patient)
    }
  }
  
  private func errorMessage(_ error: DayLogsVMError) -> LocalizedStringResource {
    switch error {
    case .noPateint:
      return "환자 정보가 없어요."
    case .noDeviceID:
      return "연결된 장치를 찾을 수 없어요."
    case .internalError:
      return "알 수 없는 오류가 발생했어요."
    }
  }
}

fileprivate struct DayLogDateColumnElement: View {
  @Environment(\.theme) private var theme
  var columnWidth: CGFloat
  var rowHeight: CGFloat
  var log: DayLog
  
  var body: some View {
    Text(log.day, format: .dateTime.year().month().day())
      .textStyle(theme.textTheme.emphasizedTitleMedium)
      .foregroundColorSet(theme.colorTheme.primary)
      .frame(width: columnWidth, height: rowHeight)
      .overlay(alignment: .bottom) {
          Rectangle().frame(height: 1)
              .foregroundColorSet(theme.colorTheme.outline)
      }
  }
}

fileprivate struct DayLogRow: View {
  @Environment(\.theme) private var theme
  var columnWidth: CGFloat
  var rowHeight: CGFloat
  var dayLog: DayLog
  
  var body: some View {
    HStack(spacing: 0) {
      Group {
        Text(TimeFormatter.formattedDuration(seconds: dayLog.totalOcciputTime))
        Text(TimeFormatter.formattedDuration(seconds: dayLog.totalScapulaTime))
        Text(TimeFormatter.formattedDuration(seconds: dayLog.totalRightElbowTime))
        Text(TimeFormatter.formattedDuration(seconds: dayLog.totalLeftElbowTime))
        Text(TimeFormatter.formattedDuration(seconds: dayLog.totalHipTime))
        Text(TimeFormatter.formattedDuration(seconds: dayLog.totalRightHeelTime))
        Text(TimeFormatter.formattedDuration(seconds: dayLog.totalLeftHeelTime))
      }
      .textStyle(theme.textTheme.bodyLarge)
      .frame(width: columnWidth, height: rowHeight)
    }
    .backgroundColorSet(theme.colorTheme.surfaceContainer)
    .overlay(alignment: .bottom) {
      // Divider
      Rectangle()
        .frame(height: 1)
        .foregroundColorSet(theme.colorTheme.outline)
    }
  }
}

#Preview {
  DayLogsView(
    patient: Patient(
      id: 2625083234860015468, createdAt: .now,
      uid: UUID(uuidString: "d9542f41-2177-4522-a833-b48afeff8b19")!,
      name: "",
      occiputThreshold: nil,
      scapulaThreshold: nil,
      rightElbowThreshold: nil,
      leftElbowThreshold: nil,
      hipThreshold: nil,
      rightHeelThreshold: nil,
      leftHeelThreshold: nil
    )
  )
}
