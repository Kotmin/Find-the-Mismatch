//
//  SortCardsView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct SortCardsView: View {
    @Bindable var viewModel: SortCardsViewModel

    @State private var dragOffsets: [UUID: CGSize] = [:]
    
    @State private var draggingCardID: UUID? = nil


    // Dealing
    @State private var dealt: Set<UUID> = []
    @State private var dealingTask: Task<Void, Never>? = nil

    // Stable per-card deal rotation (so it doesn’t change when SwiftUI re-renders)
    @State private var dealRotationByID: [UUID: Double] = [:]

    var body: some View {
        GeometryReader { geometry in
            let zoneCount = max(viewModel.zoneCategories.count, 1)
            let zoneHeight = geometry.size.height / CGFloat(zoneCount)

            let cardSize = computeCardSize(boardSize: geometry.size, zoneHeight: zoneHeight)

            let dealOrigin = CGPoint(
                x: geometry.size.width * GameLayout.sortDealOriginXFactor,
                y: zoneHeight * GameLayout.sortDealOriginYFactor
            )

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
                    let finalPosition = position(
                        for: card,
                        in: geometry.size,
                        zoneIndex: zoneIndex,
                        zoneHeight: zoneHeight,
                        cardSize: cardSize
                    )

                    let locked = isLockedCorrect(card)
                    let isDealt = dealt.contains(card.id)
                    let dragOffset = dragOffsets[card.id] ?? .zero
                    let dealRotation = dealRotationByID[card.id] ?? 0

                    CardView(card: card)
                        .frame(width: cardSize.width, height: cardSize.height)
                        .position(isDealt ? finalPosition : dealOrigin)
                        .offset(isDealt ? dragOffset : .zero)
                        .scaleEffect(isDealt ? 1.0 : GameLayout.sortDealStartScale)
                        .opacity(isDealt ? 1.0 : GameLayout.sortDealStartOpacity)
                        .rotationEffect(.degrees(isDealt ? 0 : dealRotation))
                        .allowsHitTesting(isDealt && !locked)
                        .gesture(dragGesture(
                            for: card,
                            zoneHeight: zoneHeight,
                            zoneCount: zoneCount,
                            locked: locked,
                            isDealt: isDealt
                        ))
                        .zIndex(locked ? 2 : 1)
                }
            }
            .coordinateSpace(name: "board")
            .onAppear {
                prepareDealingStateIfNeeded()
                restartDealing()
            }
            .onChange(of: viewModel.cards.map(\.id)) { _, _ in
                prepareDealingStateIfNeeded()
                restartDealing()
            }
            .onDisappear {
                dealingTask?.cancel()
                dealingTask = nil
            }
        }
    }
}

// MARK: - Dealing

private extension SortCardsView {
    func prepareDealingStateIfNeeded() {
        // ensure every card has a stable deal rotation
        if dealRotationByID.count != viewModel.cards.count {
            var map: [UUID: Double] = [:]
            map.reserveCapacity(viewModel.cards.count)

            for card in viewModel.cards {
                // Deterministic-ish but still demonstrate variation:
                // use UUID hash to pick a stable angle in [-max, +max]
                let max = GameLayout.sortDealMaxRotationDegrees
                let h = abs(card.id.uuidString.hashValue)
                let unit = Double(h % 1000) / 1000.0
                let angle = (unit * 2.0 - 1.0) * max
                map[card.id] = angle
            }
            dealRotationByID = map
        }
    }

    func restartDealing() {
        dealingTask?.cancel()
        dealingTask = nil

        dealt = []
        dragOffsets = [:]

        let idsInOrder = viewModel.cards.map(\.id)

        dealingTask = Task { @MainActor in
            for (index, id) in idsInOrder.enumerated() {
                if Task.isCancelled { return }

                let delayNanos = UInt64(Double(index) * GameLayout.sortDealStaggerSeconds * 500_000_000)
                try? await Task.sleep(nanoseconds: delayNanos)

                _ = withAnimation(GameLayout.sortDealAnimation) {
                    dealt.insert(id)
                }

            }
        }
    }
}

// MARK: - Gesture

private extension SortCardsView {
    func dragGesture(
        for card: Card,
        zoneHeight: CGFloat,
        zoneCount: Int,
        locked: Bool,
        isDealt: Bool
    ) -> some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("board"))
            .onChanged { value in
                guard isDealt, !locked else { return }
                draggingCardID = card.id

                var tx = Transaction()
                tx.animation = nil
                withTransaction(tx) {
                    dragOffsets[card.id] = value.translation
                }
            }
            .onEnded { value in
                guard isDealt, !locked else { return }

                draggingCardID = nil

                let location = value.location
                let targetIndex = targetZoneIndex(
                    for: location,
                    zoneHeight: zoneHeight,
                    zoneCount: zoneCount
                )
                let targetCategory = viewModel.zoneCategories[targetIndex]

                withAnimation(.easeOut(duration: GameLayout.sortDragSnapBackDuration)) {
                    dragOffsets[card.id] = .zero
                }

                viewModel.handleDrop(card: card, into: targetCategory)
            }

    }
}

// MARK: - Existing helpers

private extension SortCardsView {
    func isLockedCorrect(_ card: Card) -> Bool {
        card.assignedCategory == card.category
    }

    func zoneIndexForCard(_ card: Card) -> Int {
        if let assigned = card.assignedCategory,
           let index = viewModel.zoneCategories.firstIndex(where: { $0 == assigned }) {
            return index
        } else {
            return 0
        }
    }

    func computeCardSize(boardSize: CGSize, zoneHeight: CGFloat) -> CGSize {
        let baseWidth = boardSize.width / GameLayout.sortBaseWidthDivisor
        let widthFromScreen = max(
            GameLayout.sortCardMinWidth,
            min(GameLayout.sortCardMaxWidth, baseWidth)
        )

        let maxHeightInZone = zoneHeight * GameLayout.sortCardHeightInZoneFactor
        let widthFromHeight = maxHeightInZone / GameLayout.cardAspectRatio
        let cardWidth = min(widthFromScreen, widthFromHeight)
        let cardHeight = cardWidth * GameLayout.cardAspectRatio

        return CGSize(width: cardWidth, height: cardHeight)
    }

    func position(
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

        let zoneTop = CGFloat(zoneIndex) * zoneHeight
        let isLandscape = size.width > size.height

        // Neutral zone (index 0) - 5 piles in landscape when many cards
        if zoneIndex == 0, isLandscape, cardsInZone.count > GameLayout.sortNeutralPilesThreshold {
            let pileCount = min(GameLayout.sortNeutralMaxPileCount, cardsInZone.count)
            let pileIndex = localIndex % pileCount
            let depthIndex = localIndex / pileCount

            let spacingX: CGFloat = cardSize.width * GameLayout.sortNeutralPileSpacingXFactor
            let layoutWidth = CGFloat(pileCount) * cardSize.width
                + CGFloat(max(pileCount - 1, 0)) * spacingX
            let left = max(0, (size.width - layoutWidth) / 2)

            let x = left
                + cardSize.width / 2
                + CGFloat(pileIndex) * (cardSize.width + spacingX)

            let zoneCenterY = zoneTop + zoneHeight * GameLayout.sortNeutralPileCenterYFactor
            let depthOffset = cardSize.height * GameLayout.sortNeutralPileDepthOffsetFactor

            var y = zoneCenterY + CGFloat(depthIndex) * depthOffset

            let bottomMargin = zoneHeight * GameLayout.sortZoneBottomMarginFactor
            let maxY = zoneTop + zoneHeight - bottomMargin - cardSize.height / 2
            y = min(y, maxY)

            return CGPoint(x: x, y: y)
        }

        let columns = max(GameLayout.sortMinColumns, Int(size.width / (cardSize.width * GameLayout.sortColumnsWidthFactor)))
        let column = localIndex % columns
        let row = localIndex / columns

        let spacingX: CGFloat = cardSize.width * GameLayout.sortGridSpacingXFactor
        let layoutWidth = CGFloat(columns) * cardSize.width
            + CGFloat(max(columns - 1, 0)) * spacingX
        let left = max(0, (size.width - layoutWidth) / 2)

        let x = left
            + cardSize.width / 2
            + CGFloat(column) * (cardSize.width + spacingX)

        let totalRows = (cardsInZone.count + columns - 1) / columns
        let spacingY: CGFloat = cardSize.height * GameLayout.sortGridSpacingYFactor
        let contentHeight = CGFloat(totalRows) * cardSize.height
            + CGFloat(max(totalRows - 1, 0)) * spacingY

        let zoneCenterY = zoneTop + zoneHeight / 2
        let startY = zoneCenterY - contentHeight / 2

        let yRaw = startY
            + cardSize.height / 2
            + CGFloat(row) * (cardSize.height + spacingY)

        let topLimit = zoneTop + cardSize.height / 2
        let bottomMargin = zoneHeight * GameLayout.sortZoneBottomMarginFactor
        let bottomLimit = zoneTop + zoneHeight - bottomMargin - cardSize.height / 2

        let y = min(max(yRaw, topLimit), bottomLimit)
        return CGPoint(x: x, y: y)
    }

    func targetZoneIndex(for location: CGPoint, zoneHeight: CGFloat, zoneCount: Int) -> Int {
        let safeHeight = max(zoneHeight, 1)
        let rawIndex = Int(location.y / safeHeight)
        return min(max(rawIndex, 0), zoneCount - 1)
    }

    func zoneColor(for index: Int, category: Category?) -> Color {
        if category == nil {
            return Color(uiColor: .systemBackground)
        }

        let colors: [Color] = [.blue, .orange, .pink, .purple, .mint, .yellow]
        return colors[index % colors.count].opacity(GameLayout.sortZoneBackgroundOpacity)
    }
}
