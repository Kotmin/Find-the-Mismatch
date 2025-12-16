//
//  QuickManualView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 16/12/2025.
//


import SwiftUI

struct QuickManualView: View {
    let mode: GameMode
    let onStart: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                header

                rulesCard

                startButton
            }
            .padding(24)
            .frame(maxWidth: 420)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.background)
                    .shadow(radius: 20)
            )
            .padding()
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Text(titleEmoji)
                .font(.system(size: 44))

            Text(title)
                .font(.title2.bold())

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var rulesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(rules, id: \.self) { rule in
                HStack(alignment: .top, spacing: 10) {
                    Text("•")
                        .font(.headline)

                    Text(rule)
                        .font(.callout)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
        )
    }

    private var startButton: some View {
        Button(action: onStart) {
            Text("🚀 Start game")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
    }

    // MARK: - Content

    private var title: String {
        mode == .findMismatch ? "Find the Mismatch" : "Sort the Cards"
    }

    private var subtitle: String {
        "Quick rules before you begin"
    }

    private var titleEmoji: String {
        mode == .findMismatch ? "🔍" : "🗂️"
    }

    private var rules: [String] {
        var common = [
            "⏱️ When time is up — you lose.",
            "❤️ When hearts reach zero — you lose.",
            "🔥 3 correct guesses in a row grant an extra heart.",
            "✨ Winning rounds in a streak gives a score multiplier."
        ]

        switch mode {
        case .findMismatch:
            common.insert(
                "🧠 You must mark all cards belonging to a hidden category chosen by the game.",
                at: 0
            )
        case .sortCards:
            common.insert(
                "🖐️ Drag and drop cards into zones — one zone equals one category.",
                at: 0
            )
            common.insert(
                "✅ Correct drops turn cards green. ❌ Wrong ones turn red briefly.",
                at: 1
            )
        }

        return common
    }
}
