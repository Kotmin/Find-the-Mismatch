//
//  GameModeRoundViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//


import Foundation

@MainActor
protocol GameModeRoundViewModel: AnyObject {
    var timerViewModel: TimerViewModel { get }
    var isRoundActive: Bool { get set }
    var onIncorrectSelection: (() -> Void)? { get set }
    var onRoundCompleted: ((GameResult) -> Void)? { get set }

    func resetIfNeeded(for mode: GameMode)
    func endRoundDueToTimeUp()
}

extension GameModeRoundViewModel {
    func endRoundDueToTimeUp() {
        isRoundActive = false
    }
}
