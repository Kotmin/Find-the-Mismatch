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
    let detailText: String?
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
                    .foregroundColor(.primary)

                Text("Score: \(score)")
                    .font(.headline)
                    .foregroundColor(.primary)

                if let detailText {
                    Text(detailText)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 4)
                }

                HStack(spacing: 16) {
                    Button {
                        onMainMenu()
                    } label: {
                        Text("Main menu")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .foregroundColor(.primary)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
                    }

                    Button {
                        onRestart()
                    } label: {
                        Text("Once again?")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .foregroundColor(.primary)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(12)
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
        case .preparing:
            return "Preparation"
        }
    }
}
