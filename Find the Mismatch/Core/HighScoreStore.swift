//
//  HighScoreStore.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

struct HighScoreStore {
    private let storageKey = "high_scores"

    func loadAll() -> [GameMode: HighScore] {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            return [:]
        }
        guard let decoded = try? JSONDecoder().decode([StoredHighScore].self, from: data) else {
            return [:]
        }
        var result: [GameMode: HighScore] = [:]
        for item in decoded {
            result[item.mode] = HighScore(
                mode: item.mode,
                bestScore: item.bestScore,
                bestStreak: item.bestStreak
            )
        }
        return result
    }

    func saveAll(_ scores: [GameMode: HighScore]) {
        let array = scores.values.map {
            StoredHighScore(
                mode: $0.mode,
                bestScore: $0.bestScore,
                bestStreak: $0.bestStreak
            )
        }
        guard let data = try? JSONEncoder().encode(array) else {
            return
        }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

private struct StoredHighScore: Codable {
    let mode: GameMode
    let bestScore: Int
    let bestStreak: Int
}
