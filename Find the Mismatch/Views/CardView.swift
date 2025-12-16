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
            assetView
            Text(card.title)
                .font(.footnote)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
                .allowsTightening(true)
        }
        .padding(GameLayout.cardInnerPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .cornerRadius(GameLayout.cardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: GameLayout.cardCornerRadius)
                .stroke(borderColor, lineWidth: GameLayout.cardBorderWidth)
        )
        .opacity(card.isVisible ? 1 : 0)
        .animation(.easeInOut(duration: GameLayout.defaultFadeDuration), value: card.isVisible)
        .animation(.easeInOut(duration: GameLayout.defaultFadeDuration), value: card.isHighlightedCorrect)
        .animation(.easeInOut(duration: GameLayout.defaultFadeDuration), value: card.isHighlightedIncorrect)
    }

    @ViewBuilder
    private var assetView: some View {
        switch card.asset {
        case .emoji(let value):
            Text(value)
                .font(.title)
                .foregroundColor(.primary)
        case .image(let name):
            Image(name)
                .resizable()
                .scaledToFit()
        }
    }

    private var backgroundColor: Color {
        if card.isHighlightedCorrect {
            return Color.green.opacity(GameLayout.correctHighlightOpacity)
        } else if card.isHighlightedIncorrect {
            return Color.red.opacity(GameLayout.incorrectHighlightOpacity)
        } else {
            return Color(uiColor: .secondarySystemBackground)
        }
    }

    private var borderColor: Color {
        if card.isHighlightedCorrect {
            return .green
        } else if card.isHighlightedIncorrect {
            return .red
        } else {
            return .gray.opacity(GameLayout.defaultBorderOpacity)
        }
    }
}
