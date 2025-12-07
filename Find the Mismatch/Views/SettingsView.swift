//
//  SettingsView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct SettingsView: View {
    var viewModel: RootViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Toggle(
                "Shake on wrong answer",
                isOn: Binding(
                    get: { viewModel.isShakeOnWrong },
                    set: { viewModel.isShakeOnWrong = $0 }
                )
            )
            .padding(.top, 24)
            .padding(.trailing)

            Toggle(
                "Dark mode",
                isOn: Binding(
                    get: { viewModel.isDarkModeEnabled },
                    set: { viewModel.isDarkModeEnabled = $0 }
                )
            )
            .padding(.trailing)

            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
