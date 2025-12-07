//
//  RootViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

@MainActor
@Observable
final class RootViewModel {
    private let gameEngine = GameEngine()

    var screen: RootScreen
    var gameState: GameState
    var activeMode: GameMode
    var headerViewModel: GameHeaderViewModel
    var timerViewModel: TimerViewModel
    var findMismatchViewModel: FindMismatchViewModel
    var sortCardsViewModel: SortCardsViewModel
    var menuViewModel: MenuViewModel
    var currentStreaks: [GameMode: Int]
    var lastRoundScore: Int
    var isShakeOnWrong: Bool {
        didSet {
            UserDefaults.standard.set(isShakeOnWrong, forKey: "settings_shakeOnWrong")
        }
    }
    var themeMode: ThemeMode {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: "settings_themeMode")
        }
    }
    var shakeCounter: Int
    var greenPulseCounter: Int


    init() {
        let initialMode = GameMode.findMismatch
        let initialState = gameEngine.initialGameState(for: initialMode)

        let timerViewModel = TimerViewModel(
            duration: AppConfig.defaultRoundDuration
        )

        let headerViewModel = GameHeaderViewModel(
            hearts: initialState.hearts,
            maxHearts: initialState.maxHearts,
            mode: initialMode,
            result: .inProgress,
            timerViewModel: timerViewModel
        )

        let findMismatchViewModel = FindMismatchViewModel(
            timerViewModel: timerViewModel
        )

        let sortCardsViewModel = SortCardsViewModel(
            timerViewModel: timerViewModel
        )

        let menuViewModel = MenuViewModel()

        let initialShake = UserDefaults.standard.object(forKey: "settings_shakeOnWrong") as? Bool ?? true
        let storedTheme = UserDefaults.standard.string(forKey: "settings_themeMode")
        let initialTheme = ThemeMode(rawValue: storedTheme ?? "") ?? .system

        self.screen = .menu
        self.gameState = initialState
        self.activeMode = initialMode
        self.timerViewModel = timerViewModel
        self.headerViewModel = headerViewModel
        self.findMismatchViewModel = findMismatchViewModel
        self.sortCardsViewModel = sortCardsViewModel
        self.menuViewModel = menuViewModel
        self.currentStreaks = [:]
        self.lastRoundScore = 0
        self.isShakeOnWrong = initialShake
        self.themeMode = initialTheme
        self.shakeCounter = 0
        self.greenPulseCounter = 0


        self.timerViewModel.onCompleted = { [weak self] in
            self?.handleTimeUp()
        }

        self.findMismatchViewModel.onIncorrectSelection = { [weak self] in
            self?.handleIncorrectSelection()
        }

        self.findMismatchViewModel.onRoundCompleted = { [weak self] result in
            self?.updateResult(result)
        }

        self.sortCardsViewModel.onIncorrectSelection = { [weak self] in
            self?.handleIncorrectSelection()
        }

        self.sortCardsViewModel.onRoundCompleted = { [weak self] result in
            self?.updateResult(result)
        }

        self.findMismatchViewModel.onExtraHeartEarned = { [weak self] in
            self?.updateHearts(by: 1)
            self?.triggerGreenPulse()
        }

        self.sortCardsViewModel.onExtraHeartEarned = { [weak self] in
            self?.updateHearts(by: 1)
            self?.triggerGreenPulse()
        }

    }

    func openMenu() {
        timerViewModel.resetToFull()
        screen = .menu
    }

    func openSettings() {
        screen = .settings
    }

    func startGame(mode: GameMode) {
        activeMode = mode
        resetGame()
        screen = .game
    }

    func switchMode(_ mode: GameMode) {
        activeMode = mode
        resetGame()
    }

    func resetGame() {
        gameState = gameEngine.initialGameState(for: activeMode)
        headerViewModel.update(
            hearts: gameState.hearts,
            maxHearts: gameState.maxHearts,
            mode: gameState.mode,
            result: gameState.result
        )
        timerViewModel.restart()
        findMismatchViewModel.resetIfNeeded(for: activeMode)
        sortCardsViewModel.resetIfNeeded(for: activeMode)
    }

    func updateHearts(by delta: Int) {
        let newValue = max(0, gameState.hearts + delta)
        gameState.hearts = newValue
        headerViewModel.updateHearts(newValue)

        if newValue == 0 {
            updateResult(.lost)
        }
    }

    func updateResult(_ result: GameResult) {
        gameState.result = result
        headerViewModel.updateResult(result)
        if result != .inProgress {
            timerViewModel.stop()
            recordHighScoreIfNeeded(result: result)
        }
    }

    private func handleIncorrectSelection() {
        updateHearts(by: -1)
        if isShakeOnWrong {
            triggerShake()
        }
    }

    private func triggerShake() {
        shakeCounter += 1
    }
    
    private func triggerGreenPulse() {
        greenPulseCounter += 1
    }


    private func handleTimeUp() {
        if gameState.result == .inProgress {
            findMismatchViewModel.endRoundDueToTimeUp()
            sortCardsViewModel.endRoundDueToTimeUp()
            updateResult(.timeUp)
        }
    }

    private func recordHighScoreIfNeeded(result: GameResult) {
        let score: Int
        switch activeMode {
        case .findMismatch:
            score = findMismatchViewModel.correctSelectionsCount
        case .sortCards:
            score = sortCardsViewModel.currentScore
        }

        lastRoundScore = score

        var streak = currentStreaks[activeMode] ?? 0
        if result == .won {
            streak += 1
        } else {
            streak = 0
        }
        currentStreaks[activeMode] = streak

        menuViewModel.updateHighScore(
            for: activeMode,
            score: score,
            streak: streak
        )
    }
    
    var currentScore: Int {
        switch activeMode {
        case .findMismatch:
            return findMismatchViewModel.correctSelectionsCount
        case .sortCards:
            return sortCardsViewModel.currentScore
        }
    }

}
