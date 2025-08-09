//
//  RotateCircleLayout.swift
//  BedSolution
//
//  Created by 이재호 on 8/8/25.
//


import Foundation
import SwiftUI
import Combine

/// 회전 방향
enum RotationDirection { case clockwise, counterclockwise }

extension Collection {
    /// 무작위로 `count`개를 뽑아 배열 반환
    func randomSample(_ count: Int) -> [Element] {
        guard !isEmpty, count > 0 else { return [] }
        let n = Swift.min(count, self.count)
        return Array(self.shuffled().prefix(n))
    }
}

/// 지정된 반지름으로 자식 뷰들을 원 둘레에 배치하고, `phase`(라디안) 변경에 따라 회전하는 Layout
/// - `radius`: 원의 반지름 (포인트)
/// - `phase`: 회전 위상 (라디안, 시계 방향 양수)
/// - `startAngle`: 시작 각도 (기본값: -90°, 즉 12시 방향에서 시작)
/// - `direction`: 시계/반시계 회전 정의 (phase에 부호 적용)
/// - `edgeOnCircle`: true면 각 뷰의 바깥 가장자리가 원을 따라가도록 배치 (기본 false는 뷰의 중심이 원 위)
struct RotateCircleLayout: Layout, Animatable {
    var radius: CGFloat
    var phase: Double = 0
    var startAngle: Angle = .degrees(-90)
    var direction: RotationDirection = .clockwise
    var edgeOnCircle: Bool = false

    // `phase`를 애니메이션 가능하게
    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let diameter = radius * 2
        let w = max(proposal.width ?? diameter, diameter)
        let h = max(proposal.height ?? diameter, diameter)
        return CGSize(width: w, height: h)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        guard !subviews.isEmpty else { return }

        let n = subviews.count
        let step = (2 * .pi) / Double(n)
        // iOS 좌표계(y+ 아래) 특성상 양의 각 증가는 시계 방향 회전
        let dir: Double = (direction == .clockwise) ? 1 : -1
        let base = startAngle.radians + dir * phase

        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        for (i, subview) in subviews.enumerated() {
            let angle = base + step * Double(i)

            // 뷰의 외곽을 원에 붙일지 여부에 따라 반지름 보정
            var r = radius
            if edgeOnCircle {
                // 대략적인 외접원 반지름(최대 변 길이의 절반)으로 보정
                let sz = subview.sizeThatFits(.unspecified)
                let half = max(sz.width, sz.height) / 2
                r = max(0, radius - half)
            }

            let x = center.x + r * CGFloat(cos(angle))
            let y = center.y + r * CGFloat(sin(angle))

            subview.place(
                at: CGPoint(x: x, y: y),
                anchor: .center,
                proposal: .unspecified
            )
        }
    }
}

/// `TimelineView(.animation)`을 사용해 주기적으로 회전시키는 래퍼 뷰
struct RotatingCircle<Content: View>: View {
    var radius: CGFloat
    var period: TimeInterval = 12 // 한 바퀴 도는 데 걸리는 시간(초)
    var direction: RotationDirection = .clockwise
    var startAngle: Angle = .degrees(-90)
    var edgeOnCircle: Bool = false
    private let content: () -> Content

    init(
        radius: CGFloat,
        period: TimeInterval = 12,
        direction: RotationDirection = .clockwise,
        startAngle: Angle = .degrees(-90),
        edgeOnCircle: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.radius = radius
        self.period = period
        self.direction = direction
        self.startAngle = startAngle
        self.edgeOnCircle = edgeOnCircle
        self.content = content
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let omega = (2 * .pi / period) * (direction == .clockwise ? 1 : -1)
            let phase = t * omega

            RotateCircleLayout(
                radius: radius,
                phase: phase,
                startAngle: startAngle,
                direction: direction,
                edgeOnCircle: edgeOnCircle
            ) {
                content()
            }
        }
    }
}

#if swift(>=5.9)
/// 고정 각도(stepAngle)만큼 주기적으로 회전시키는 래퍼 뷰 (각 이동은 easeInOut 애니메이션)
struct StepRotatingCircle<Content: View>: View {
    var radius: CGFloat
    var stepAngle: Angle                       // 각 스텝당 회전 각도
    var stepInterval: TimeInterval = 1.2       // 스텝 간 간격(초)
    var moveDuration: TimeInterval = 0.5       // 각 스텝 이동 애니메이션 시간(초)
    var direction: RotationDirection = .clockwise
    var startAngle: Angle = .degrees(-90)
    var edgeOnCircle: Bool = false
    var isRunning: Bool = true
    var onStep: ((Int) -> Void)? = nil
    private let content: () -> Content

    private let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @State private var step: Int = 0
    @State private var phase: Double = 0

    init(
        radius: CGFloat,
        stepAngle: Angle,
        stepInterval: TimeInterval = 1.2,
        moveDuration: TimeInterval = 0.5,
        direction: RotationDirection = .clockwise,
        startAngle: Angle = .degrees(-90),
        edgeOnCircle: Bool = false,
        isRunning: Bool = true,
        onStep: ((Int) -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.radius = radius
        self.stepAngle = stepAngle
        self.stepInterval = stepInterval
        self.moveDuration = moveDuration
        self.direction = direction
        self.startAngle = startAngle
        self.edgeOnCircle = edgeOnCircle
        self.isRunning = isRunning
        self.content = content
        self.timer = Timer.publish(every: stepInterval, on: .main, in: .common).autoconnect()
        self.onStep = onStep
    }

    var body: some View {
        RotateCircleLayout(
            radius: radius,
            phase: phase,
            startAngle: startAngle,
            direction: direction,
            edgeOnCircle: edgeOnCircle
        ) {
            content()
        }
        .onReceive(timer) { _ in
            guard isRunning else { return }
            step += 1
            onStep?(step)
            // 방향 부호는 Layout 내부에서 적용되므로 여기서는 누적 phase만 양수로 증가
            let target = Double(step) * stepAngle.radians
            withAnimation(.easeInOut(duration: moveDuration)) {
                phase = target
            }
        }
    }
}
#endif

#if swift(>=5.9)
/// 스텝마다 무작위로 몇 개만 보여주는 데모 (간격 재배치 버전)
struct RandomPickDemo: View {
    @State private var visible: [Int] = []
    private let all = Array(0..<10)
    var body: some View {
        StepRotatingCircle(
            radius: 110,
            stepAngle: .degrees(360/10),
            stepInterval: 1.0,
            moveDuration: 0.45,
            direction: .clockwise,
            onStep: { _ in
                visible = all.randomSample(4) // 매 스텝마다 4개 무작위 선택
            }
        ) {
            ForEach(visible, id: \.self) { i in
                ZStack {
                    Circle().frame(width: 28, height: 28)
                    Text("\(i)").font(.caption2)
                }
            }
        }
        .frame(width: 260, height: 260)
        .onAppear { visible = all.randomSample(4) }
    }
}
#endif

#Preview("RotateCircleLayout Demo") {
#if swift(>=5.9)
    VStack {
        // 8개 아이템, 한 칸(360/8°)씩 시계 방향으로 step 이동, 각 이동은 easeInOut
        StepRotatingCircle(
            radius: 110,
            stepAngle: .degrees(360/8),
            stepInterval: 1.0,
            moveDuration: 0.45,
            direction: .clockwise
        ) {
            ForEach(0..<8) { i in
                ZStack {
                    Circle().frame(width: 28, height: 28)
                    Text("\(i)").font(.caption2)
                }
            }
        }
        .frame(width: 260, height: 260)
        .padding()

        // 6개 아이템, 반시계 방향으로 두 칸씩(120°) 이동, 가장자리를 원에 맞춤
        StepRotatingCircle(
            radius: 110,
            stepAngle: .degrees((360/6) * 2),
            stepInterval: 1.4,
            moveDuration: 0.5,
            direction: .counterclockwise,
            edgeOnCircle: true
        ) {
            ForEach(0..<6) { _ in
                Image(systemName: "star.fill")
                    .font(.title2)
            }
        }
        .frame(width: 260, height: 260)

        // 랜덤으로 4개만 표시 (스텝마다 변경)
        RandomPickDemo()
        .padding(.top, 12)
    }
#endif
}
