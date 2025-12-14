//
//  FindMismatchView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct FindMismatchView: View {
    @Bindable var viewModel: FindMismatchViewModel

    var body: some View {
        GeometryReader { geometry in
            content(for: geometry.size)
        }
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

            let spacing: CGFloat = 8
            let horizontalPadding: CGFloat = 16
            let verticalPadding: CGFloat = 16

            let columns = Array(
                repeating: GridItem(.fixed(layout.cardSize.width), spacing: spacing),
                count: layout.columns
            )

            let grid = LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .frame(width: layout.cardSize.width, height: layout.cardSize.height)
                        .onTapGesture {
                            viewModel.handleTap(on: card)
                        }
                }
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)

            if mustFitHeight && layout.fitsHeight {
                grid
            } else {
                ScrollView {
                    grid
                }
            }
        }
    }

    private func bestLayout(
        containerSize: CGSize,
        cardCount: Int,
        mustFitHeight: Bool
    ) -> (columns: Int, rows: Int, cardSize: CGSize, fitsHeight: Bool) {
        let spacing: CGFloat = 8
        let horizontalPadding: CGFloat = 16
        let verticalPadding: CGFloat = 16

        let availableWidth = max(
            containerSize.width - horizontalPadding * 2,
            1
        )

        // HORIZONTAL / >40 CARDS MODE:
        // "Show as many cards as possible" – we prefer more columns instead of giant cards.
        if !mustFitHeight {
            let rawColumns = Int(availableWidth / AppConfig.cardMinWidth)
            let maxColumns = max(1, min(cardCount, 10))
            let columns = max(1, min(rawColumns, maxColumns))

            let totalSpacingWidth = spacing * CGFloat(max(columns - 1, 0))
            let rawCardWidth = (availableWidth - totalSpacingWidth) / CGFloat(columns)

            let cardWidth = max(
                AppConfig.cardMinWidth,
                min(AppConfig.cardMaxWidth, rawCardWidth)
            )

            let cardHeight = cardWidth * AppConfig.cardAspectRatio
            let rows = Int(ceil(Double(cardCount) / Double(columns)))

            let totalGridHeight = CGFloat(rows) * cardHeight
                + spacing * CGFloat(max(rows - 1, 0))
                + verticalPadding * 2

            let fitsHeight = totalGridHeight <= containerSize.height

            return (
                columns: columns,
                rows: rows,
                cardSize: CGSize(width: cardWidth, height: cardHeight),
                fitsHeight: fitsHeight
            )
        }

        // PORTRAIT + ≤ 40 CARDS MODE:
        // "Fit height" – we search columns and maximize card area while respecting height.
        var bestColumns = 1
        var bestRows = cardCount
        var bestCardSize = CGSize(
            width: AppConfig.cardMinWidth,
            height: AppConfig.cardMinWidth * AppConfig.cardAspectRatio
        )
        var bestFitsHeight = false
        var bestArea: CGFloat = 0

        let maxColumnsToTry = max(1, min(cardCount, 10))

        for columns in 1...maxColumnsToTry {
            let rows = Int(ceil(Double(cardCount) / Double(columns)))
            let totalSpacingWidth = spacing * CGFloat(max(columns - 1, 0))
            let rawCardWidth = (availableWidth - totalSpacingWidth) / CGFloat(columns)
            if rawCardWidth <= 0 {
                continue
            }

            let cardWidth = max(
                AppConfig.cardMinWidth,
                min(AppConfig.cardMaxWidth, rawCardWidth)
            )
            let cardHeight = cardWidth * AppConfig.cardAspectRatio

            let totalGridHeight = CGFloat(rows) * cardHeight
                + spacing * CGFloat(max(rows - 1, 0))
                + verticalPadding * 2

            let fitsHeight = totalGridHeight <= containerSize.height
            if !fitsHeight {
                continue
            }

            let area = cardWidth * cardHeight
            if bestArea == 0 || area > bestArea {
                bestArea = area
                bestColumns = columns
                bestRows = rows
                bestCardSize = CGSize(width: cardWidth, height: cardHeight)
                bestFitsHeight = fitsHeight
            }
        }

        if bestArea == 0 {
            let fallbackColumns = min(4, max(1, cardCount))
            let rows = Int(ceil(Double(cardCount) / Double(fallbackColumns)))
            let totalSpacingWidth = spacing * CGFloat(max(fallbackColumns - 1, 0))
            let rawCardWidth = (availableWidth - totalSpacingWidth) / CGFloat(fallbackColumns)
            let cardWidth = max(
                AppConfig.cardMinWidth,
                min(AppConfig.cardMaxWidth, rawCardWidth)
            )
            let cardHeight = cardWidth * AppConfig.cardAspectRatio
            let totalGridHeight = CGFloat(rows) * cardHeight
                + spacing * CGFloat(max(rows - 1, 0))
                + verticalPadding * 2
            let fitsHeight = totalGridHeight <= containerSize.height

            return (
                columns: fallbackColumns,
                rows: rows,
                cardSize: CGSize(width: cardWidth, height: cardHeight),
                fitsHeight: fitsHeight
            )
        }

        return (
            columns: bestColumns,
            rows: bestRows,
            cardSize: bestCardSize,
            fitsHeight: bestFitsHeight
        )
    }

}
