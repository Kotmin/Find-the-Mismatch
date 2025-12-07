//
//  FindMismatchViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

@MainActor
@Observable
final class FindMismatchViewModel {
    let timerViewModel: TimerViewModel

    var cards: [Card]
    var targetCategory: Category?
    var isRoundActive: Bool
    var correctSelectionsCount: Int

    var onIncorrectSelection: (() -> Void)?
    var onRoundCompleted: ((GameResult) -> Void)?

    init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
        self.cards = []
        self.targetCategory = nil
        self.isRoundActive = false
        self.correctSelectionsCount = 0
        generateInitialCards()
    }

    func resetIfNeeded(for mode: GameMode) {
        if mode == .findMismatch {
            generateInitialCards()
        }
    }

    func generateInitialCards() {
        let definitions = CardCatalog.shared.all.shuffled()
        let availableCount = definitions.count

        if availableCount == 0 {
            cards = []
            targetCategory = nil
            isRoundActive = false
            correctSelectionsCount = 0
            return
        }

        let minCount = AppConfig.minCardsPerRound
        let count: Int
        if availableCount <= minCount {
            count = availableCount
        } else {
            count = Int.random(in: minCount...availableCount)
        }

        let selected = Array(definitions.prefix(count))

        cards = selected.map { definition in
            Card(
                title: definition.title,
                asset: definition.asset,
                category: definition.category
            )
        }

        let categoriesInRound = Array(Set(cards.map { $0.category }))
        targetCategory = categoriesInRound.randomElement()
        isRoundActive = true
        correctSelectionsCount = 0
    }

    func handleTap(on card: Card) {
        guard isRoundActive else { return }
        guard let targetCategory else { return }
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }

        let current = cards[index]
        if current.isHighlightedCorrect || current.isHighlightedIncorrect {
            return
        }

        let isCorrect = current.category == targetCategory

        if isCorrect {
            cards[index].isHighlightedCorrect = true
            correctSelectionsCount += 1
            checkForRoundCompletion()
        } else {
            cards[index].isHighlightedIncorrect = true
            onIncorrectSelection?()
            let cardId = current.id
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(3))
                if let idx = cards.firstIndex(where: { $0.id == cardId }) {
                    cards[idx].isHighlightedIncorrect = false
                }
            }
        }
    }

    private func checkForRoundCompletion() {
        guard let targetCategory else { return }
        let allTargetCards = cards.filter { $0.category == targetCategory }
        let allHighlighted = allTargetCards.allSatisfy { $0.isHighlightedCorrect }

        if allHighlighted {
            isRoundActive = false
            onRoundCompleted?(.won)
        }
    }

    func endRoundDueToTimeUp() {
        isRoundActive = false
    }
}
