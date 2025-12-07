//
//  MenuView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct MenuView: View {
    var rootViewModel: RootViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Find the Mismatch?")
                    .font(.largeTitle)
                    .padding(.top, 32)

                VStack(spacing: 16) {
                    modeRow(
                        title: "Find the mismatch",
                        mode: .findMismatch
                    )

                    modeRow(
                        title: "Sort the cards",
                        mode: .sortCards
                    )

                    // Future modes can be added here
                }
                .padding(.horizontal)

                Spacer(minLength: 32)
            }
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func modeRow(title: String, mode: GameMode) -> some View {
        let bestScore = rootViewModel.menuViewModel.bestScore(for: mode)
        let bestStreak = rootViewModel.menuViewModel.bestStreak(for: mode)

        Button {
            rootViewModel.startGame(mode: mode)
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text("Best score: \(bestScore)")
                        .font(.subheadline)
                    Text("Best streak: \(bestStreak)")
                        .font(.subheadline)
                }
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(16)
        }
    }
}
