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
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: 2)
        )
        .opacity(card.isVisible ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: card.isVisible)
        .animation(.easeInOut(duration: 0.2), value: card.isHighlightedCorrect)
        .animation(.easeInOut(duration: 0.2), value: card.isHighlightedIncorrect)
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
            return Color.green.opacity(0.7)
        } else if card.isHighlightedIncorrect {
            return Color.red.opacity(0.7)
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
            return .gray.opacity(0.4)
        }
    }
}
