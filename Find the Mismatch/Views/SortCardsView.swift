//
//  SortCardsView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct SortCardsView: View {
    var viewModel: SortCardsViewModel

    @State private var dragOffsets: [UUID: CGSize] = [:]

    var body: some View {
        GeometryReader { geometry in
            let zoneCount = max(viewModel.zoneCategories.count, 1)
            let zoneHeight = geometry.size.height / CGFloat(zoneCount)

            let baseWidth = geometry.size.width / 6
            let widthFromScreen = max(
                AppConfig.cardMinWidth,
                min(AppConfig.cardMaxWidth, baseWidth)
            )

            let maxHeightInZone = zoneHeight * 0.6
//            let widthFromHeight = maxHeightInZone / AppConfig.cardAspectRatio
            let widthFromHeight = maxHeightInZone / (2.0 / 3.0)
            let cardWidth = min(widthFromScreen, widthFromHeight)
//            let cardHeight = cardWidth * AppConfig.cardAspectRatio
            let cardHeight = cardWidth * (2.0 / 3.0)
            let cardSize = CGSize(width: cardWidth, height: cardHeight)

            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.zoneCategories.enumerated()), id: \.offset) { index, category in
                        Rectangle()
                            .fill(zoneColor(for: index, category: category))
                            .frame(height: zoneHeight)
                    }
                }

                ForEach(viewModel.cards) { card in
                    let zoneIndex = zoneIndexForCard(card)
                    let position = position(
                        for: card,
                        in: geometry.size,
                        zoneIndex: zoneIndex,
                        zoneHeight: zoneHeight,
                        cardSize: cardSize
                    )

                    CardView(card: card)
                        .frame(width: cardSize.width, height: cardSize.height)
                        .position(position)
                        .offset(dragOffsets[card.id] ?? .zero)
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .named("board"))
                                .onChanged { value in
                                    dragOffsets[card.id] = value.translation
                                }
                                .onEnded { value in
                                    let location = value.location
                                    let targetIndex = targetZoneIndex(
                                        for: location,
                                        zoneHeight: zoneHeight,
                                        zoneCount: zoneCount
                                    )
                                    let targetCategory = viewModel.zoneCategories[targetIndex]
                                    dragOffsets[card.id] = .zero
                                    viewModel.handleDrop(card: card, into: targetCategory)
                                }
                        )
                }
            }
            .coordinateSpace(name: "board")
        }
    }

    private func zoneIndexForCard(_ card: Card) -> Int {
        if let assigned = card.assignedCategory,
           let index = viewModel.zoneCategories.firstIndex(where: { $0 == assigned }) {
            return index
        } else {
            return 0
        }
    }

    private func position(
        for card: Card,
        in size: CGSize,
        zoneIndex: Int,
        zoneHeight: CGFloat,
        cardSize: CGSize
    ) -> CGPoint {
        let cardsInZone = viewModel.cards.filter { zoneIndexForCard($0) == zoneIndex }
        guard let localIndex = cardsInZone.firstIndex(where: { $0.id == card.id }) else {
            let zoneTop = CGFloat(zoneIndex) * zoneHeight
            let zoneCenterY = zoneTop + zoneHeight / 2
            return CGPoint(x: size.width / 2, y: zoneCenterY)
        }

        let columns = max(2, Int(size.width / (cardSize.width * 1.3)))
        let column = localIndex % columns
        let row = localIndex / columns

        let horizontalSpacing = size.width / CGFloat(columns + 1)
        let x = horizontalSpacing * CGFloat(column + 1)

        let zoneTop = CGFloat(zoneIndex) * zoneHeight
        let verticalSpacing: CGFloat = cardSize.height * 0.2
        let baseOffset = zoneHeight * 0.05

        let y = zoneTop
            + baseOffset
            + cardSize.height / 2
            + CGFloat(row) * (cardSize.height + verticalSpacing)

        let maxY = zoneTop + zoneHeight - cardSize.height / 2
        let clampedY = min(y, maxY)

        return CGPoint(x: x, y: clampedY)
    }

    private func targetZoneIndex(for location: CGPoint, zoneHeight: CGFloat, zoneCount: Int) -> Int {
        let safeHeight = zoneHeight > 0 ? zoneHeight : 1
        let rawIndex = Int(location.y / safeHeight)
        return min(max(rawIndex, 0), zoneCount - 1)
    }

    private func zoneColor(for index: Int, category: Category?) -> Color {
        if category == nil {
            return Color(uiColor: .systemBackground)
        }

        let colors: [Color] = [
            .blue,
            .orange,
            .pink,
            .purple,
            .mint,
            .yellow
        ]

        let colorIndex = index % colors.count
        return colors[colorIndex].opacity(0.6)
    }
}
