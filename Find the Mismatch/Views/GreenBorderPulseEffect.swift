//
//  GreenBorderPulseEffect.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//


import SwiftUI

struct GreenBorderPulseEffect: ViewModifier {
    let trigger: Int

    @State private var isActive = false

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    let cornerRadius: CGFloat = 20
                    let lineWidth: CGFloat = isActive ? 6 : 0
                    let opacity: CGFloat = isActive ? 0.9 : 0

                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.green, lineWidth: lineWidth)
                        .opacity(opacity)
                        .padding(4)
                        .animation(.easeOut(duration: 0.25), value: isActive)
                }
            )
            .onChange(of: trigger) { _ in
                isActive = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    isActive = false
                }
            }
    }
}

extension View {
    func greenBorderPulse(trigger: Int) -> some View {
        modifier(GreenBorderPulseEffect(trigger: trigger))
    }
}
