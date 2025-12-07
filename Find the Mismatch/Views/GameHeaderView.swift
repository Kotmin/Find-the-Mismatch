//
//  GameHeaderView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct GameHeaderView: View {
    var viewModel: GameHeaderViewModel
    var showsMenuButton: Bool
    var onMenuButtonTap: (() -> Void)?
    var showsSettingsButton: Bool
    var onSettingsButtonTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(viewModel.heartsDisplay)
                    .font(.title2)

                Spacer()

                Text(viewModel.statusText)
                    .font(.headline)

                Spacer()

                HStack(spacing: 12) {
                    if showsSettingsButton {
                        Button {
                            onSettingsButtonTap?()
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.title3)
                        }
                    }

                    if showsMenuButton {
                        Button {
                            onMenuButtonTap?()
                        } label: {
                            Image(systemName: "house")
                                .font(.title3)
                        }
                    }
                }
            }

            TimerBarView(viewModel: viewModel.timerViewModel)
                .frame(height: 12)
        }
        .padding()
    }
}
