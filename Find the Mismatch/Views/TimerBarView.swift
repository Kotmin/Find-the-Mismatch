//
//  SwiftUIView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct TimerBarView: View {
    @Bindable var viewModel: TimerViewModel
    @State private var blink = false

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * viewModel.progress

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.2))

                Capsule()
                    .fill(barColor)
                    .frame(width: width)
                    .opacity(barOpacity)
                    .animation(.easeInOut(duration: GameLayout.timerProgressAnimDuration), value: viewModel.progress)
                    .animation(.easeInOut(duration: GameLayout.timerBlinkAnimDuration).repeatForever(autoreverses: true), value: blink)
            }
            .onChange(of: viewModel.progress) { _, newValue in
                blink = newValue < GameLayout.timerWarningThreshold
            }
            .onAppear {
                blink = viewModel.progress < GameLayout.timerWarningThreshold
            }
        }
    }

    private var barColor: Color {
        let p = viewModel.progress
        if p > GameLayout.timerGreenThreshold {
            return .green
        } else if p > GameLayout.timerYellowThreshold {
            return .yellow
        } else {
            return .red
        }
    }

    private var barOpacity: Double {
        if viewModel.progress < GameLayout.timerWarningThreshold && blink {
            return GameLayout.timerBlinkOpacity
        } else {
            return 1
        }
    }
}
