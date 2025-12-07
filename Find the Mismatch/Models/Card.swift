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
    let asset: CardAsset
    let category: Category
    var isVisible: Bool
    var isHighlightedCorrect: Bool
    var isHighlightedIncorrect: Bool
    var assignedCategory: Category?

    init(
        id: UUID = UUID(),
        title: String,
        asset: CardAsset,
        category: Category,
        isVisible: Bool = true,
        isHighlightedCorrect: Bool = false,
        isHighlightedIncorrect: Bool = false,
        assignedCategory: Category? = nil
    ) {
        self.id = id
        self.title = title
        self.asset = asset
        self.category = category
        self.isVisible = isVisible
        self.isHighlightedCorrect = isHighlightedCorrect
        self.isHighlightedIncorrect = isHighlightedIncorrect
        self.assignedCategory = assignedCategory
    }
}
