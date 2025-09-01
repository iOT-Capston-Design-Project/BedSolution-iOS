//
//  HumanConfig.swift
//  BedSolution
//
//  Created by 이재호 on 8/7/25.
//

import SwiftUI

struct HumanConfig: View {
    @Environment(\.theme) private var theme
    @Binding var cautionOcciput: Bool
    @Binding var cautionScapula: Bool
    @Binding var cautionElbow: Bool
    @Binding var cautionHip: Bool
    @Binding var cautionHeel: Bool
    
    var body: some View {
        ZStack {
            Image(.humanBody)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            ZStack {
                spot(isActive: cautionHeel)
                    .onTapGesture { cautionHeel.toggle() }
                label(text: "발꿈치", isActive: cautionHeel)
                    .offset(x: 30, y: -20)
            }
            .offset(x: 23, y: 190)
            .animation(.default, value: cautionHeel)
            
            ZStack {
                spot(isActive: cautionHip)
                    .onTapGesture { cautionHip.toggle() }
                label(text: "엉덩뼈", isActive: cautionHip)
                    .offset(x: 40, y: 5)
            }
            .animation(.default, value: cautionHip)
            
            ZStack {
                spot(isActive: cautionElbow)
                    .onTapGesture { cautionElbow.toggle() }
                label(text: "팔꿈치", isActive: cautionElbow)
                    .offset(x: 38, y: -10)
            }
            .offset(x: 65, y: -55)
            .animation(.default, value: cautionElbow)
            
            ZStack {
                spot(isActive: cautionScapula)
                    .onTapGesture { cautionScapula.toggle() }
                label(text: "견갑골", isActive: cautionScapula)
                    .offset(x: 40, y: 0)
            }
            .offset(x: 36, y: -120)
            .animation(.default, value: cautionScapula)
            
            ZStack {
                spot(isActive: cautionOcciput)
                    .onTapGesture { cautionOcciput.toggle() }
                label(text: "뒤통수", isActive: cautionOcciput)
                    .offset(x: 0, y: -30)
            }
            .offset(x: 0, y: -160)
            .animation(.default, value: cautionOcciput)
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
    private func label(text: LocalizedStringResource, isActive: Bool) -> some View {
        Text(text)
            .textStyle(theme.textTheme.emphasizedLabelLarge)
            .foregroundColorSet(isActive ? theme.colorTheme.onErrorContainer: theme.colorTheme.onSurfaceVarient)
            .padding(EdgeInsets(top: 1, leading: 5, bottom: 1, trailing: 5))
            .backgroundColorSet(isActive ? theme.colorTheme.errorContainer: theme.colorTheme.surfaceContainerHigh, in: Capsule())
    }
}

#Preview {
    @Previewable @State var cautionOcciput: Bool = false
    @Previewable @State var cautionScapula: Bool = false
    @Previewable @State var cautionElbow: Bool = false
    @Previewable @State var cautionHip: Bool = false
    @Previewable @State var cautionHeel: Bool = false
    HumanConfig(cautionOcciput: $cautionOcciput, cautionScapula: $cautionScapula, cautionElbow: $cautionElbow, cautionHip: $cautionHip, cautionHeel: $cautionHeel)
}
