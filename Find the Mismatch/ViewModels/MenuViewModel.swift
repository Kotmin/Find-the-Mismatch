//
//  MenuViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

@MainActor
@Observable
final class MenuViewModel {
    private let highScoreStore: HighScoreStore

    var highScores: [GameMode: HighScore]

    init(highScoreStore: HighScoreStore = HighScoreStore()) {
        self.highScoreStore = highScoreStore
        self.highScores = highScoreStore.loadAll()
    }

    func bestScore(for mode: GameMode) -> Int {
        highScores[mode]?.bestScore ?? 0
    }

    func bestStreak(for mode: GameMode) -> Int {
        highScores[mode]?.bestStreak ?? 0
    }

    func updateHighScore(for mode: GameMode, score: Int, streak: Int) {
        let existing = highScores[mode]
        let bestScore = max(existing?.bestScore ?? 0, score)
        let bestStreak = max(existing?.bestStreak ?? 0, streak)
        highScores[mode] = HighScore(
            mode: mode,
            bestScore: bestScore,
            bestStreak: bestStreak
        )
        highScoreStore.saveAll(highScores)
    }
}
