//
//  AppConfig.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

struct AppConfig {
    static let defaultHearts = 4
    static let defaultRoundDuration: TimeInterval = 30
    
    static let minCardsPerRound = 6

    static let sortCardsPerCategory = 3
    
    static let minSortCategories: Int = 2
    static let maxSortCategories: Int = 4
    
    static let cardMinWidth: CGFloat = 60
    static let cardMaxWidth: CGFloat = 100
    static let cardAspectRatio: CGFloat = 1.2
}
