//
//  AppConfig.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation
import CoreGraphics

struct AppConfig {
    static let defaultHearts = 5
    static let defaultRoundDuration: TimeInterval = 30

    static let minCardsPerRound: Int = 6

    static let sortCardsPerCategory: Int = 3
    static let minSortCategories: Int = 2
    static let maxSortCategories: Int = 4

    static let cardMinWidth: CGFloat = 80
    static let cardMaxWidth: CGFloat = 330
    static let cardAspectRatio: CGFloat = 1.2

    static let maxFindMismatchCardsWithoutScroll: Int = 20
    
    static let maxFindMismatchCards: Int = 60
    
    static let extraHeartCorrectStreak = 3
}
