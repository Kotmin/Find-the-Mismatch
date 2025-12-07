//
//  Find_the_MismatchApp.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import SwiftUI

@main
struct Find_the_MismatchApp: App {
    @State private var rootViewModel = RootViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: rootViewModel)
        }
    }
}
