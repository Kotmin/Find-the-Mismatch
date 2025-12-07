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
        let templates: [(String, String, Category)] = [
            ("Dog", "🐶", .animals),
            ("Cat", "🐱", .animals),
            ("Mouse", "🐭", .animals),
            ("Pizza", "🍕", .food),
            ("Apple", "🍎", .food),
            ("Burger", "🍔", .food),
            ("Chair", "🪑", .objects),
            ("Laptop", "💻", .objects),
            ("Key", "🔑", .objects),
            ("Sun", "☀️", .weather),
            ("Cloud", "☁️", .weather),
            ("Rainbow", "🌈", .weather)
        ]

        let allCategories = Category.allCases.shuffled()
        let categoriesCount = Int.random(in: 2...min(3, allCategories.count))
        let selectedCategories = Array(allCategories.prefix(categoriesCount))

        zoneCategories = [nil] + selectedCategories

        let filtered = templates.filter { selectedCategories.contains($0.2) }.shuffled()
        let minCount = 6
        let maxCount = filtered.count
        let count = max(minCount, min(maxCount, Int.random(in: minCount...maxCount)))
        let selectedCards = Array(filtered.prefix(count))

        cards = selectedCards.map { item in
            Card(
                title: item.0,
                emoji: item.1,
                category: item.2
            )
        }

        currentScore = 0
        isRoundActive = true
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
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(3))
                if let idx = cards.firstIndex(where: { $0.id == cardId }) {
                    cards[idx].isHighlightedIncorrect = false
                }
            }
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
