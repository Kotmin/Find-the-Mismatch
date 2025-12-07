//
//  RootView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct RootView: View {
    var viewModel: RootViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                GameHeaderView(
                    viewModel: viewModel.headerViewModel,
                    showsMenuButton: viewModel.screen == .game,
                    onMenuButtonTap: {
                        viewModel.openMenu()
                    }
                )

                switch viewModel.screen {
                case .menu:
                    MenuView(rootViewModel: viewModel)
                case .game:
                    GameContainerView(
                        rootViewModel: viewModel,
                        size: geometry.size
                    )
                }
            }
        }
    }
}
