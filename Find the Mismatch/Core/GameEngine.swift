//
//  GameEngine.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

struct GameEngine {
    func initialGameState(for mode: GameMode) -> GameState {
        GameState(
            mode: mode,
            hearts: AppConfig.defaultHearts,
            maxHearts: AppConfig.defaultHearts,
            result: .inProgress
        )
    }
}
