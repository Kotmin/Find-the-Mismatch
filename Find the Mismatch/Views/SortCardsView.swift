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

            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.zoneCategories.enumerated()), id: \.offset) { index, category in
                        Rectangle()
                            .fill(zoneColor(for: index, category: category))
                            .frame(height: zoneHeight)
                    }
                }

                ForEach(viewModel.cards) { card in
                    let zoneIndex = zoneIndex(for: card)
                    let position = position(for: card, in: geometry.size, zoneIndex: zoneIndex, zoneHeight: zoneHeight)

                    CardView(card: card)
                        .frame(width: 90, height: 120)
                        .position(position)
                        .offset(dragOffsets[card.id] ?? .zero)
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .named("board"))
                                .onChanged { value in
                                    dragOffsets[card.id] = value.translation
                                }
                                .onEnded { value in
                                    let location = value.location
                                    let targetIndex = targetZoneIndex(for: location, zoneHeight: zoneHeight, zoneCount: zoneCount)
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

    private func zoneIndex(for card: Card) -> Int {
        if let assigned = card.assignedCategory,
           let index = viewModel.zoneCategories.firstIndex(where: { $0 == assigned }) {
            return index
        } else {
            return 0
        }
    }

    private func position(for card: Card, in size: CGSize, zoneIndex: Int, zoneHeight: CGFloat) -> CGPoint {
        let index = viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? 0
        let columns = 3
        let column = index % columns
        let row = index / columns

        let horizontalSpacing = size.width / CGFloat(columns + 1)
        let x = horizontalSpacing * CGFloat(column + 1)

        let zoneTop = CGFloat(zoneIndex) * zoneHeight
        let zoneCenterY = zoneTop + zoneHeight * 0.5
        let y = zoneCenterY + CGFloat(row) * 10

        return CGPoint(x: x, y: y)
    }

    private func targetZoneIndex(for location: CGPoint, zoneHeight: CGFloat, zoneCount: Int) -> Int {
        let rawIndex = Int(location.y / max(zoneHeight, 1))
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

