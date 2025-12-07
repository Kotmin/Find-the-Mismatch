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

    init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
        self.cards = []
        generateInitialCards()
    }

    func resetIfNeeded(for mode: GameMode) {
        if mode == .sortCards {
            generateInitialCards()
        }
    }

    func generateInitialCards() {
        cards = []
    }

    func handleDrop(card: Card, into zoneCategory: Category?) {
    }
}

