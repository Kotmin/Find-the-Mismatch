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
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .allowsTightening(true)
        }
        .padding()
        .frame(minWidth: 60, minHeight: 80)
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
                .font(.largeTitle)
                .foregroundColor(.primary)
        case .image(let name):
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(height: 40)
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
