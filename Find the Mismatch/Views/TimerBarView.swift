//
//  SwiftUIView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI


struct TimerBarView: View {
    var viewModel: TimerViewModel

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
                    .animation(.easeInOut(duration: 0.2), value: viewModel.progress)
                    .animation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true), value: blink)
            }
            .onChange(of: viewModel.progress) { _, newValue in
                if newValue < 0.25 {
                    blink = true
                } else {
                    blink = false
                }
            }
            .onAppear {
                if viewModel.progress < 0.25 {
                    blink = true
                }
            }
        }
    }

    private var barColor: Color {
        let p = viewModel.progress
        if p > 0.4 {
            return .green
        } else if p > 0.25 {
            return .yellow
        } else {
            return .red
        }
    }

    private var barOpacity: Double {
        if viewModel.progress < 0.25 && blink {
            return 0.3
        } else {
            return 1
        }
    }
}
