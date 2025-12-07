//
//  FindMismatchViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

@MainActor
@Observable
final class FindMismatchViewModel: CardHighlightingRoundViewModel {
    let timerViewModel: TimerViewModel

    var cards: [Card]
    var targetCategory: Category?
    var isRoundActive: Bool
    var correctSelectionsCount: Int
    var correctStreak: Int

    var onIncorrectSelection: (() -> Void)?
    var onRoundCompleted: ((GameResult) -> Void)?
    var onExtraHeartEarned: (() -> Void)?

    init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
        self.cards = []
        self.targetCategory = nil
        self.isRoundActive = false
        self.correctSelectionsCount = 0
        self.correctStreak = 0
        generateInitialCards()
    }

    func resetIfNeeded(for mode: GameMode) {
        if mode == .findMismatch {
            generateInitialCards()
        }
    }

    func generateInitialCards() {
        let allDefinitions = CardCatalog.shared.all
        if allDefinitions.isEmpty {
            cards = []
            targetCategory = nil
            isRoundActive = false
            correctSelectionsCount = 0
            correctStreak = 0
            return
        }

        let allCategories = Array(Set(allDefinitions.map { $0.category })).shuffled()
        let maxCategoryCount = max(4, allCategories.count)
        let minCategoryCount = min(2, maxCategoryCount)
        let categoryCount = Int.random(in: minCategoryCount...maxCategoryCount)
        let selectedCategories = Array(allCategories.prefix(categoryCount))

        let definitions = CardCatalog.shared.definitions(for: selectedCategories).shuffled()
        let availableCount = definitions.count

        if availableCount == 0 {
            cards = []
            targetCategory = nil
            isRoundActive = false
            correctSelectionsCount = 0
            correctStreak = 0
            return
        }

        let minCount = AppConfig.minCardsPerRound
        let maxCount = min(availableCount, AppConfig.maxFindMismatchCards)

        let count: Int
        if maxCount <= minCount {
            count = maxCount
        } else {
            count = Int.random(in: minCount...maxCount)
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
        correctStreak = 0
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
            handleCorrectSelection()
            checkForRoundCompletion()
        } else {
            cards[index].isHighlightedIncorrect = true
            handleIncorrectSelection()
            onIncorrectSelection?()
            let cardId = current.id
            scheduleIncorrectReset(for: cardId)
        }
    }

    private func handleCorrectSelection() {
        correctStreak += 1
        if correctStreak >= AppConfig.extraHeartCorrectStreak {
            correctStreak = 0
            onExtraHeartEarned?()
        }
    }

    private func handleIncorrectSelection() {
        correctStreak = 0
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
}
