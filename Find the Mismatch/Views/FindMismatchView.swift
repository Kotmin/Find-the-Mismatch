//
//  FindMismatchView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct FindMismatchView: View {
    @Bindable var viewModel: FindMismatchViewModel

    @State private var dealToken: Int = 0
    @State private var dealOn: Bool = false

    var body: some View {
        GeometryReader { geometry in
            content(for: geometry.size)
        }
        .onAppear { triggerDeal() }
        .onChange(of: viewModel.cards.map(\.id)) { _, _ in triggerDeal() }
    }

    private func triggerDeal() {
        dealOn = false
        dealToken &+= 1
        DispatchQueue.main.async { dealOn = true }
    }

    @ViewBuilder
    private func content(for size: CGSize) -> some View {
        let cardCount = viewModel.cards.count

        if cardCount == 0 {
            EmptyView()
        } else {
            let isPortrait = size.height >= size.width
            let mustFitHeight = isPortrait && cardCount <= AppConfig.maxFindMismatchCardsWithoutScroll

            let layout = bestLayout(
                containerSize: size,
                cardCount: cardCount,
                mustFitHeight: mustFitHeight
            )

            let spacing = GameLayout.gridSpacing
            let horizontalPadding = GameLayout.gridHorizontalPadding
            let verticalPadding = GameLayout.gridVerticalPadding

            let columns = Array(
                repeating: GridItem(.fixed(layout.cardSize.width), spacing: spacing),
                count: layout.columns
            )

            let grid = LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
                    let delay = min(Double(index) * GameLayout.findMismatchDealPerCardDelay, GameLayout.findMismatchDealMaxDelay)

                    CardView(card: card)
                        .frame(width: layout.cardSize.width, height: layout.cardSize.height)
                        .scaleEffect(dealOn ? 1.0 : GameLayout.findMismatchDealStartScale)
                        .opacity(dealOn ? 1.0 : GameLayout.findMismatchDealStartOpacity)
                        .animation(.snappy(duration: GameLayout.findMismatchDealDuration).delay(delay), value: dealToken)
                        .onTapGesture { viewModel.handleTap(on: card) }
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)

            if mustFitHeight && layout.fitsHeight {
                grid
            } else {
                ScrollView { grid }
            }
        }
    }

    private func bestLayout(
        containerSize: CGSize,
        cardCount: Int,
        mustFitHeight: Bool
    ) -> (columns: Int, rows: Int, cardSize: CGSize, fitsHeight: Bool) {

        // HORIZONTAL / >40 CARDS MODE:
        // "Show as many cards as possible" – we prefer more columns instead of giant cards.
        
        let spacing = GameLayout.gridSpacing
        let horizontalPadding = GameLayout.gridHorizontalPadding
        let verticalPadding = GameLayout.gridVerticalPadding

        let maxColumns = GameLayout.findMismatchMaxColumns
        let fallbackColumnsCap = GameLayout.findMismatchFallbackColumnsCap

        let availableWidth = max(containerSize.width - horizontalPadding * 2, 1)

        if !mustFitHeight {
            let rawColumns = Int(availableWidth / GameLayout.findMismatchCardMinWidth)
            let columns = max(1, min(min(rawColumns, cardCount), maxColumns))

            let totalSpacingWidth = spacing * CGFloat(max(columns - 1, 0))
            let rawCardWidth = (availableWidth - totalSpacingWidth) / CGFloat(columns)

            let cardWidth = max(
                GameLayout.findMismatchCardMinWidth,
                min(GameLayout.findMismatchCardMaxWidth, rawCardWidth)
            )

            let cardHeight = cardWidth * GameLayout.cardAspectRatio
            let rows = Int(ceil(Double(cardCount) / Double(columns)))

            let totalGridHeight = CGFloat(rows) * cardHeight
                + spacing * CGFloat(max(rows - 1, 0))
                + verticalPadding * 2

            return (columns, rows, CGSize(width: cardWidth, height: cardHeight), totalGridHeight <= containerSize.height)
        }

        var bestColumns = 1
        var bestRows = cardCount
        var bestCardSize = CGSize(
            width: GameLayout.findMismatchCardMinWidth,
            height: GameLayout.findMismatchCardMinWidth * GameLayout.cardAspectRatio
        )
        var bestArea: CGFloat = 0

        let maxColumnsToTry = max(1, min(cardCount, maxColumns))

        for columns in 1...maxColumnsToTry {
            let rows = Int(ceil(Double(cardCount) / Double(columns)))
            let totalSpacingWidth = spacing * CGFloat(max(columns - 1, 0))
            let rawCardWidth = (availableWidth - totalSpacingWidth) / CGFloat(columns)
            if rawCardWidth <= 0 { continue }

            let cardWidth = max(
                GameLayout.findMismatchCardMinWidth,
                min(GameLayout.findMismatchCardMaxWidth, rawCardWidth)
            )
            let cardHeight = cardWidth * GameLayout.cardAspectRatio

            let totalGridHeight = CGFloat(rows) * cardHeight
                + spacing * CGFloat(max(rows - 1, 0))
                + verticalPadding * 2

            if totalGridHeight > containerSize.height { continue }

            let area = cardWidth * cardHeight
            if area > bestArea {
                bestArea = area
                bestColumns = columns
                bestRows = rows
                bestCardSize = CGSize(width: cardWidth, height: cardHeight)
            }
        }

        if bestArea == 0 {
            let columns = min(fallbackColumnsCap, max(1, cardCount))
            let rows = Int(ceil(Double(cardCount) / Double(columns)))

            let totalSpacingWidth = spacing * CGFloat(max(columns - 1, 0))
            let rawCardWidth = (availableWidth - totalSpacingWidth) / CGFloat(columns)

            let cardWidth = max(
                GameLayout.findMismatchCardMinWidth,
                min(GameLayout.findMismatchCardMaxWidth, rawCardWidth)
            )
            let cardHeight = cardWidth * GameLayout.cardAspectRatio

            let totalGridHeight = CGFloat(rows) * cardHeight
                + spacing * CGFloat(max(rows - 1, 0))
                + verticalPadding * 2

            return (columns, rows, CGSize(width: cardWidth, height: cardHeight), totalGridHeight <= containerSize.height)
        }

        return (bestColumns, bestRows, bestCardSize, true)
    }
}
