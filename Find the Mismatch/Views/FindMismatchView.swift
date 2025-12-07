//
//  FindMismatchView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct FindMismatchView: View {
    var viewModel: FindMismatchViewModel

    var body: some View {
        GeometryReader { geometry in
            content(for: geometry.size)
        }
    }

    private func content(for size: CGSize) -> some View {
        let baseWidth = size.width / 4
        let cardWidth = max(AppConfig.cardMinWidth, min(AppConfig.cardMaxWidth, baseWidth))
        let cardHeight = cardWidth * AppConfig.cardAspectRatio

        return ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: cardWidth))], spacing: 0) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
//                        .frame(width: cardWidth, height: cardHeight)
                        .aspectRatio(2/3,contentMode: .fit)
                        .onTapGesture {
                            viewModel.handleTap(on: card)
                        }
                }
            }
            .padding()
        }
    }
}

