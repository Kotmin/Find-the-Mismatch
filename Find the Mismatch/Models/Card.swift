//
//  Card.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

struct Card: Identifiable, Hashable {
    let id: UUID
    let title: String
    let emoji: String
    let category: Category
    var isVisible: Bool
    var isHighlightedCorrect: Bool
    var isHighlightedIncorrect: Bool
    var assignedCategory: Category?

    init(
        id: UUID = UUID(),
        title: String,
        emoji: String,
        category: Category,
        isVisible: Bool = true,
        isHighlightedCorrect: Bool = false,
        isHighlightedIncorrect: Bool = false,
        assignedCategory: Category? = nil
    ) {
        self.id = id
        self.title = title
        self.emoji = emoji
        self.category = category
        self.isVisible = isVisible
        self.isHighlightedCorrect = isHighlightedCorrect
        self.isHighlightedIncorrect = isHighlightedIncorrect
        self.assignedCategory = assignedCategory
    }
}
