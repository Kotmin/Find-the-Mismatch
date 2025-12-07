//
//  TimerViewModel.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

import Foundation

@MainActor
@Observable
final class TimerViewModel {
    private let duration: TimeInterval
    private var remainingTime: TimeInterval
    private var timer: Timer?

    var isRunning: Bool
    var onCompleted: (() -> Void)?

    init(duration: TimeInterval, onCompleted: (() -> Void)? = nil) {
        self.duration = duration
        self.remainingTime = duration
        self.isRunning = false
        self.onCompleted = onCompleted
    }

    var progress: Double {
        guard duration > 0 else { return 0 }
        return max(0, min(1, remainingTime / duration))
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.tick()
            }
        }
    }

    func restart() {
        timer?.invalidate()
        remainingTime = duration
        isRunning = false
        start()
    }
    
    func resetToFull() {
            timer?.invalidate()
            remainingTime = duration
            isRunning = false
        }

    func stop() {
        timer?.invalidate()
        isRunning = false
    }

    private func tick() {
        remainingTime -= 0.05
        if remainingTime <= 0 {
            remainingTime = 0
            stop()
            onCompleted?()
        }
    }
}
