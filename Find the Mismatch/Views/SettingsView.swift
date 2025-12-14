//
//  SettingsView.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: RootViewModel

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

            VStack(alignment: .leading, spacing: 8) {
                Text("Appearance")
                    .font(.subheadline)

                Picker("Appearance", selection: Binding(
                    get: { viewModel.themeMode },
                    set: { viewModel.themeMode = $0 }
                )) {
                    ForEach(ThemeMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.trailing)

            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
