//
//  CardView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct CardView: View {
    let card: Card

    var body: some View {
        VStack {
            Text(card.emoji)
                .font(.largeTitle)
            Text(card.title)
                .font(.caption)
        }
        .padding()
        .frame(minWidth: 60, minHeight: 80)
        .background(backgroundColor)
        .cornerRadius(12)
        .opacity(card.isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.3), value: card.isVisible)
        .animation(.easeInOut(duration: 3), value: card.isHighlightedCorrect)
        .animation(.easeInOut(duration: 3), value: card.isHighlightedIncorrect)
    }

    private var backgroundColor: Color {
        if card.isHighlightedCorrect {
            return Color.green.opacity(0.7)
        } else if card.isHighlightedIncorrect {
            return Color.red.opacity(0.7)
        } else {
            return Color.white
        }
    }
}
