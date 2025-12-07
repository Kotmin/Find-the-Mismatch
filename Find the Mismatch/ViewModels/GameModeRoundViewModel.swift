//
//  GameModeRoundViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//


import Foundation

@MainActor
protocol GameModeRoundViewModel: AnyObject {
    var timerViewModel: TimerViewModel { get }
    var isRoundActive: Bool { get set }
    var onIncorrectSelection: (() -> Void)? { get set }
    var onRoundCompleted: ((GameResult) -> Void)? { get set }

    func resetIfNeeded(for mode: GameMode)
    func endRoundDueToTimeUp()
}

extension GameModeRoundViewModel {
    func endRoundDueToTimeUp() {
        isRoundActive = false
    }
}


@MainActor
protocol CardHighlightingRoundViewModel: GameModeRoundViewModel {
    var cards: [Card] { get set }
}

extension CardHighlightingRoundViewModel {
    func scheduleIncorrectReset(for cardId: UUID, seconds: TimeInterval = 3) {
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(seconds))
            if let idx = cards.firstIndex(where: { $0.id == cardId }) {
                cards[idx].isHighlightedIncorrect = false
            }
        }
    }
}
