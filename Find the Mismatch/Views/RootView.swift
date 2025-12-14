//
//  RootView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct RootView: View {
    @Bindable var viewModel: RootViewModel

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
                   viewModel.gameState.result == .inProgress,
                   let streak = viewModel.currentStreaks[viewModel.activeMode],
                   streak > 0 {
                    ComboMultiplierBadge(multiplier: 1 + streak)
                        .padding(.top, 4)
                        .padding(.trailing, 16)
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .topTrailing
                        )
                }

                if viewModel.screen == .game,
                   viewModel.gameState.result != .inProgress {
                    EndOfRoundOverlayView(
                        result: viewModel.gameState.result,
                        score: viewModel.lastRoundScore,
                        detailText: endOfRoundDetailText(),
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
        .preferredColorScheme(colorSchemeForTheme(viewModel.themeMode))
    }


    private func centerTitleForCurrentScreen() -> String? {
        switch viewModel.screen {
        case .menu:
            return "Find the Mismatch"

        case .settings:
            return "Settings"

        case .game:
            guard viewModel.gameState.result == .inProgress else {
                return nil
            }

            let score = viewModel.currentScore
            let streak = viewModel.currentStreaks[viewModel.activeMode] ?? 0

            if streak > 0 {
                let multiplier = 1 + streak
                return "Score: \(score)  x\(multiplier)"
            } else {
                return "Score: \(score)"
            }
        }
    }
    
    private func endOfRoundDetailText() -> String? {
        let result = viewModel.gameState.result
        guard result != .inProgress else { return nil }

        switch viewModel.activeMode {
        case .findMismatch:
            if result == .won {
                return nil
            }
            if let category = viewModel.findMismatchViewModel.targetCategory {
                return "You were looking for: \(category.displayName)"
            } else {
                return nil
            }

        case .sortCards:
            if result == .won {
                return nil
            }
            let categories = viewModel.sortCardsViewModel.zoneCategories.compactMap { $0 }
            guard !categories.isEmpty else { return nil }
            let names = categories.map { $0.displayName }
            let text = names.joined(separator: ", ")
            return "Categories in this round: \(text)"
        }
    }



    private func colorSchemeForTheme(_ theme: ThemeMode) -> ColorScheme? {
        switch theme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

struct ComboMultiplierBadge: View {
    let multiplier: Int

    @State private var scale: CGFloat = 1

    var body: some View {
        Text("x\(multiplier)")
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.green.opacity(0.9))
            .foregroundColor(.white)
            .cornerRadius(12)
            .scaleEffect(scale)
            .onAppear {
                animate()
            }
            .onChange(of: multiplier) {
                animate()
            }
    }

    private func animate() {
        scale = 1
        withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
            scale = 1.3
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                scale = 1
            }
        }
    }
    
    

}

