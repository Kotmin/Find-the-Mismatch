//
//  MenuView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct MenuView: View {
    @Bindable var rootViewModel: RootViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: GameLayout.Menu.screenSpacing) {
                Text("Find the Mismatch?")
                    .font(.largeTitle)
                    .padding(.top, GameLayout.Menu.titleTopPadding)

                VStack(spacing: GameLayout.Menu.modesSpacing) {
                    modeRow(title: "Find the mismatch", mode: .findMismatch)
                    modeRow(title: "Sort the cards", mode: .sortCards)
                }
                .padding(.horizontal, GameLayout.Menu.modesHorizontalPadding)

                Spacer(minLength: GameLayout.Menu.bottomSpacerMinLength)
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
                VStack(alignment: .leading, spacing: GameLayout.Menu.rowTextSpacing) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("Best score: \(bestScore)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Best streak: \(bestStreak)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(GameLayout.Menu.rowPadding)
            .frame(maxWidth: .infinity)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(GameLayout.Menu.rowCornerRadius)
        }
    }
}
