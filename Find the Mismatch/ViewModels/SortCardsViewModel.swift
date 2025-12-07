//
//  SortCardsViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

@MainActor
@Observable
final class SortCardsViewModel {
    let timerViewModel: TimerViewModel
    var cards: [Card]
    var currentScore: Int

    init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
        self.cards = []
        self.currentScore = 0
        generateInitialCards()
    }

    func resetIfNeeded(for mode: GameMode) {
        if mode == .sortCards {
            generateInitialCards()
        }
    }

    func generateInitialCards() {
        cards = []
        currentScore = 0
    }

    func handleDrop(card: Card, into zoneCategory: Category?) {
    }
}
