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
            ZStack {
                VStack(spacing: 0) {
                    GameHeaderView(
                        viewModel: viewModel.headerViewModel,
                        showsMenuButton: viewModel.screen == .game || viewModel.screen == .settings,
                        onMenuButtonTap: {
                            viewModel.openMenu()
                        },
                        showsSettingsButton: viewModel.screen == .menu,
                        onSettingsButtonTap: {
                            viewModel.openSettings()
                        },
                        centerTitleOverride: centerTitleForCurrentScreen()
                    )

                    switch viewModel.screen {
                    case .menu:
                        MenuView(rootViewModel: viewModel)
                    case .game:
                        GameContainerView(
                            rootViewModel: viewModel,
                            size: geometry.size
                        )
                    case .settings:
                        SettingsView(viewModel: viewModel)
                    }
                }

                if viewModel.screen == .game,
                   viewModel.gameState.result != .inProgress {
                    EndOfRoundOverlayView(
                        result: viewModel.gameState.result,
                        score: viewModel.lastRoundScore,
                        onRestart: {
                            viewModel.resetGame()
                        },
                        onMainMenu: {
                            viewModel.openMenu()
                        }
                    )
                }
            }
            .modifier(
                ShakeEffect(
                    animatableData: CGFloat(viewModel.shakeCounter)
                )
            )
            .animation(.easeInOut(duration: 0.25), value: viewModel.shakeCounter)
        }
    }

    private func centerTitleForCurrentScreen() -> String? {
        switch viewModel.screen {
        case .menu:
            return "Find the Mismatch"
        case .settings:
            return "Settings"
        case .game:
            return nil
        }
    }
}
