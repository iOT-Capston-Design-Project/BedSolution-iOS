//
//  HumanConfig.swift
//  BedSolution
//
//  Created by 이재호 on 8/7/25.
//

import SwiftUI

struct HumanConfig: View {
    @Environment(\.theme) private var theme
    @Binding var occiputTime: Int?
    @Binding var scapulaTime: Int?
    @Binding var elbowTime: Int?
    @Binding var hipTime: Int?
    @Binding var heelTime: Int?
    
    var body: some View {
        ZStack {
            Image(.humanBody)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            ZStack {
                spot(isActive: heelTime != nil)
                    .onTapGesture {
                        heelTime = heelTime == nil ? 60: nil
                    }
                label(text: "발꿈치", time: heelTime)
                    .offset(y: -30)
            }
            .offset(x: 23, y: 190)
            .animation(.default, value: heelTime)
            
            ZStack {
                spot(isActive: hipTime != nil)
                    .onTapGesture {
                        hipTime = hipTime == nil ? 60: nil
                    }
                label(text: "엉덩뼈", time: hipTime)
                    .offset(y: 30)
            }
            .animation(.default, value: hipTime)
            
            ZStack {
                spot(isActive: elbowTime != nil)
                    .onTapGesture {
                        elbowTime = elbowTime == nil ? 60: nil
                    }
                label(text: "팔꿈치", time: elbowTime)
                    .offset(x: 25, y: 30)
            }
            .offset(x: 65, y: -55)
            .animation(.default, value: elbowTime)
            
            ZStack {
                spot(isActive: scapulaTime != nil)
                    .onTapGesture {
                        scapulaTime = scapulaTime == nil ? 60: nil
                    }
                label(text: "견갑골", time: scapulaTime)
                    .offset(x: 0, y: 30)
            }
            .offset(x: 36, y: -120)
            .animation(.default, value: scapulaTime)
            
            ZStack {
                spot(isActive: occiputTime != nil)
                    .onTapGesture {
                        occiputTime = occiputTime == nil ? 60: nil
                    }
                label(text: "뒤통수", time: occiputTime)
                    .offset(y: -30)
            }
            .offset(x: 0, y: -160)
            .animation(.default, value: occiputTime)
        }
        .frame(height: 400)
    }
    
    @ViewBuilder
    private func spot(isActive: Bool) -> some View {
        let outSize: CGFloat = isActive ? 30: 25
        let inSize: CGFloat = isActive ? 20: 17
        
        Circle()
            .frame(width: outSize, height: outSize)
            .foregroundColorSet(isActive ? theme.colorTheme.error: theme.colorTheme.onSurfaceVarient)
            .opacity(0.3)
            .overlay {
                Circle()
                    .frame(width: inSize, height: inSize)
                    .foregroundColorSet(isActive ? theme.colorTheme.error: theme.colorTheme.onSurfaceVarient)
                    .opacity(0.8)
            }
    }
    
    @ViewBuilder
    private func label(text: LocalizedStringResource, time: Int?) -> some View {
        let isActive = time != nil
        HStack(spacing: 5) {
            Text(text)
            if let time {
                Text(TimeFormatter.formattedDuration(from: time))
            }
        }
        .textStyle(theme.textTheme.emphasizedLabelLarge)
        .foregroundColorSet(isActive ? theme.colorTheme.onErrorContainer: theme.colorTheme.onSurfaceVarient)
        .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
        .backgroundColorSet(isActive ? theme.colorTheme.errorContainer: theme.colorTheme.surfaceContainerHigh, in: Capsule())
    }
}



#Preview {
    @Previewable @State var occiputTime: Int?
    @Previewable @State var scapulaTime: Int?
    @Previewable @State var elbowTime: Int?
    @Previewable @State var hipTime: Int?
    @Previewable @State var heelTime: Int?
    HumanConfig(occiputTime: $occiputTime, scapulaTime: $scapulaTime, elbowTime: $elbowTime, hipTime: $hipTime, heelTime: $heelTime)
}
