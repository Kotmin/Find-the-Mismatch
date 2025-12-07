//
//  SortCardsViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

@MainActor
@Observable
final class SortCardsViewModel: CardHighlightingRoundViewModel {
    let timerViewModel: TimerViewModel

    var cards: [Card]
    var zoneCategories: [Category?]
    var currentScore: Int
    var isRoundActive: Bool

    var onIncorrectSelection: (() -> Void)?
    var onRoundCompleted: ((GameResult) -> Void)?

    init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
        self.cards = []
        self.zoneCategories = []
        self.currentScore = 0
        self.isRoundActive = false
        generateInitialCards()
    }

    func resetIfNeeded(for mode: GameMode) {
        if mode == .sortCards {
            generateInitialCards()
        }
    }

    func generateInitialCards() {
        let catalog = CardCatalog.shared

        let availableCategories = Category.allCases.filter { category in
            !catalog.definitions(for: category).isEmpty
        }

        if availableCategories.isEmpty {
            zoneCategories = [nil]
            cards = []
            currentScore = 0
            isRoundActive = false
            return
        }

        let minCategories = AppConfig.minSortCategories
        let maxCategories = min(AppConfig.maxSortCategories, availableCategories.count)

        let categoriesCount: Int
        if maxCategories <= minCategories {
            categoriesCount = maxCategories
        } else {
            categoriesCount = Int.random(in: minCategories...maxCategories)
        }

        let selectedCategories = Array(availableCategories.shuffled().prefix(categoriesCount))
        zoneCategories = [nil] + selectedCategories

        var generatedCards: [Card] = []

        for category in selectedCategories {
            let definitions = catalog.definitions(for: category).shuffled()
            if definitions.isEmpty {
                continue
            }

            let maxPerCategory = AppConfig.sortCardsPerCategory
            let count = min(maxPerCategory, definitions.count)
            let selected = definitions.prefix(count)

            for definition in selected {
                let card = Card(
                    title: definition.title,
                    asset: definition.asset,
                    category: definition.category
                )
                generatedCards.append(card)
            }
        }

        cards = generatedCards
        currentScore = 0
        isRoundActive = !cards.isEmpty
    }

    func handleDrop(card: Card, into zoneCategory: Category?) {
        guard isRoundActive else { return }
        guard let index = cards.firstIndex(where: { $0.id == card.id }) else { return }

        if zoneCategory == nil {
            cards[index].assignedCategory = nil
            cards[index].isHighlightedCorrect = false
            cards[index].isHighlightedIncorrect = false
            return
        }

        let isCorrect = card.category == zoneCategory

        if isCorrect {
            cards[index].assignedCategory = zoneCategory
            cards[index].isHighlightedCorrect = true
            cards[index].isHighlightedIncorrect = false
            currentScore += 1
            checkForRoundCompletion()
        } else {
            cards[index].isHighlightedIncorrect = true
            cards[index].isHighlightedCorrect = false
            onIncorrectSelection?()
            let cardId = card.id
            scheduleIncorrectReset(for: cardId)
        }
    }

    private func checkForRoundCompletion() {
        let allPlaced = cards.allSatisfy { card in
            card.assignedCategory != nil && card.assignedCategory == card.category
        }

        if allPlaced {
            isRoundActive = false
            onRoundCompleted?(.won)
        }
    }

}
