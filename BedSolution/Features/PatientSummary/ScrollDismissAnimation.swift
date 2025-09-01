//
//  ScrollDismissAnimation.swift
//  BedSolution
//
//  Created by 이재호 on 8/16/25.
//

import Foundation
import SwiftUI

private struct ScrollDismissAnimation: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scrollTransition(.interactive) { effect, phase in
                effect
                    .opacity(phase.isIdentity ? 1: 0.3)
                    .scaleEffect(CGSize(width: phase.isIdentity ? 1: 0.9, height: phase.isIdentity ? 1: 0.9))
            }
    }
}

extension View {
    public func scrollDismissAnimation() -> some View {
        modifier(ScrollDismissAnimation())
    }
}
