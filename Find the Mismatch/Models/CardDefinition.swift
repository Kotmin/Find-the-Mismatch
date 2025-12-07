//
//  CardDefinition.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//


import Foundation

struct CardDefinition {
    let id: String
    let title: String
    let asset: CardAsset
    let category: Category
}

struct CardCatalog {
    static let shared = CardCatalog()

    let all: [CardDefinition]

    private init() {
        all = [
            CardDefinition(id: "dog", title: "Dog", asset: .emoji("🐶"), category: .animals),
            CardDefinition(id: "cat", title: "Cat", asset: .emoji("🐱"), category: .animals),
            CardDefinition(id: "mouse", title: "Mouse", asset: .emoji("🐭"), category: .animals),
            CardDefinition(id: "pizza", title: "Pizza", asset: .emoji("🍕"), category: .food),
            CardDefinition(id: "apple", title: "Apple", asset: .emoji("🍎"), category: .food),
            CardDefinition(id: "burger", title: "Burger", asset: .emoji("🍔"), category: .food),
            CardDefinition(id: "chair", title: "Chair", asset: .emoji("🪑"), category: .objects),
            CardDefinition(id: "laptop", title: "Laptop", asset: .emoji("💻"), category: .objects),
            CardDefinition(id: "key", title: "Key", asset: .emoji("🔑"), category: .objects),
            CardDefinition(id: "sun", title: "Sun", asset: .emoji("☀️"), category: .weather),
            CardDefinition(id: "cloud", title: "Cloud", asset: .emoji("☁️"), category: .weather),
            CardDefinition(id: "rainbow", title: "Rainbow", asset: .emoji("🌈"), category: .weather)
        ]
    }

    func definitions(for categories: [Category]) -> [CardDefinition] {
        all.filter { categories.contains($0.category) }
    }

    func definitions(for category: Category) -> [CardDefinition] {
        all.filter { $0.category == category }
    }
}
