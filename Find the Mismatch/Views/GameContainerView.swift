//
//  GameContainerView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct GameContainerView: View {
    var rootViewModel: RootViewModel
    var size: CGSize

    var body: some View {
        VStack {
            Picker("", selection: Binding(
                get: { rootViewModel.activeMode },
                set: { rootViewModel.switchMode($0) }
            )) {
                Text("Find mismatch").tag(GameMode.findMismatch)
                Text("Sort cards").tag(GameMode.sortCards)
            }
            .pickerStyle(.segmented)
            .padding()
            
            
            contentView
        }.greenBorderPulse(trigger: rootViewModel.greenPulseCounter)
    }

    @ViewBuilder
    private var contentView: some View {
        switch rootViewModel.activeMode {
        case .findMismatch:
            FindMismatchView(viewModel: rootViewModel.findMismatchViewModel)
        case .sortCards:
            SortCardsView(viewModel: rootViewModel.sortCardsViewModel)
        }
    }
}
