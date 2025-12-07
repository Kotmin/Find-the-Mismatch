//
//  GameHeaderViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

@MainActor
@Observable
final class GameHeaderViewModel {
    var hearts: Int
    var maxHearts: Int
    var mode: GameMode
    var result: GameResult
    let timerViewModel: TimerViewModel

    init(
        hearts: Int,
        maxHearts: Int,
        mode: GameMode,
        result: GameResult,
        timerViewModel: TimerViewModel
    ) {
        self.hearts = hearts
        self.maxHearts = maxHearts
        self.mode = mode
        self.result = result
        self.timerViewModel = timerViewModel
    }

    func update(
        hearts: Int,
        maxHearts: Int,
        mode: GameMode,
        result: GameResult
    ) {
        self.hearts = hearts
        self.maxHearts = maxHearts
        self.mode = mode
        self.result = result
    }

    func updateHearts(_ hearts: Int) {
        self.hearts = hearts
    }

    func updateResult(_ result: GameResult) {
        self.result = result
    }

    var heartsDisplay: String {
        if hearts <= 3 {
            String(repeating: "❤", count: max(hearts, 0))
        } else {
            "\(hearts) x ❤"
        }
    }

    var statusText: String {
        switch result {
        case .inProgress:
            switch mode {
            case .findMismatch:
                return "Find the mismatch"
            case .sortCards:
                return "Sort the cards"
            }
        case .won:
            return "You won"
        case .lost:
            return "Out of hearts"
        case .timeUp:
            return "Time is up"
        }
    }
}

