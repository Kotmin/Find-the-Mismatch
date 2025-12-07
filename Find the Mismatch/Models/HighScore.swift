//
//  HighScore.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

struct HighScore: Codable {
    let mode: GameMode
    let bestScore: Int
    let bestStreak: Int
}

