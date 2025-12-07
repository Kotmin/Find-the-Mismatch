//
//  EndOfRoundOverlayView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//


import SwiftUI

struct EndOfRoundOverlayView: View {
    let result: GameResult
    let score: Int
    let onRestart: () -> Void
    let onMainMenu: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text(titleText)
                    .font(.title)
                    .bold()

                Text("Score: \(score)")
                    .font(.headline)

                HStack(spacing: 16) {
                    Button {
                        onMainMenu()
                    } label: {
                        Text("Main menu")
                            .frame(maxWidth: .infinity)
                    }

                    Button {
                        onRestart()
                    } label: {
                        Text("Restart")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.top, 8)
            }
            .padding()
            .frame(maxWidth: 320)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
        }
    }

    private var titleText: String {
        switch result {
        case .won:
            return "You won"
        case .lost:
            return "Out of hearts"
        case .timeUp:
            return "Time is up"
        case .inProgress:
            return ""
        }
    }
}
