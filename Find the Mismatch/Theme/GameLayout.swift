//
//  GameLayout.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//


import SwiftUI

struct GameLayout {
    static let findMismatchCardMinWidth: CGFloat = 120
    static let findMismatchCardMaxWidth: CGFloat = 160
    static let cardAspectRatio: CGFloat = 0.7

    static let sortCardMinWidth: CGFloat = 90
    static let sortCardMaxWidth: CGFloat = 130

    static let cardCornerRadius: CGFloat = 12
    static let cardBorderWidth: CGFloat = 2

    // MARK: - Shared UI spacing / animation

    static let cardInnerPadding: CGFloat = 8
    static let gridSpacing: CGFloat = 8
    static let gridHorizontalPadding: CGFloat = 16
    static let gridVerticalPadding: CGFloat = 16

    static let defaultFadeDuration: Double = 0.2

    // MARK: - Card highlight colors

    static let correctHighlightOpacity: Double = 0.7
    static let incorrectHighlightOpacity: Double = 0.7
    static let defaultBorderOpacity: Double = 0.4

    // MARK: - Timer thresholds

    static let timerWarningThreshold: Double = 0.25
    static let timerYellowThreshold: Double = 0.25
    static let timerGreenThreshold: Double = 0.4

    static let timerBlinkOpacity: Double = 0.3
    static let timerProgressAnimDuration: Double = 0.2
    static let timerBlinkAnimDuration: Double = 0.4
    
    
    // MARK: - Find Mismatch
    static let findMismatchMaxColumns: Int = 10
    static let findMismatchFallbackColumnsCap: Int = 4

    static let findMismatchDealDuration: Double = 0.18
    static let findMismatchDealPerCardDelay: Double = 0.004
    static let findMismatchDealMaxDelay: Double = 0.08
    static let findMismatchDealStartScale: CGFloat = 0.94
    static let findMismatchDealStartOpacity: Double = 0.0


    // MARK: - Sort Cards layout

    static let sortBaseWidthDivisor: CGFloat = 6
    static let sortCardHeightInZoneFactor: CGFloat = 0.6

    static let sortColumnsWidthFactor: CGFloat = 1.3
    static let sortMinColumns: Int = 2

    static let sortGridSpacingXFactor: CGFloat = 0.2
    static let sortGridSpacingYFactor: CGFloat = 0.2

    static let sortZoneBottomMarginFactor: CGFloat = 0.05

    static let sortNeutralPilesThreshold: Int = 5
    static let sortNeutralMaxPileCount: Int = 5
    static let sortNeutralPileSpacingXFactor: CGFloat = 0.3
    static let sortNeutralPileCenterYFactor: CGFloat = 0.2
    static let sortNeutralPileDepthOffsetFactor: CGFloat = 0.15

    static let sortZoneBackgroundOpacity: Double = 0.6

    // MARK: - Sort Cards dealing animation

    static let sortDealStaggerSeconds: Double = 0.028
    static let sortDealStartScale: CGFloat = 0.86
    static let sortDealStartOpacity: Double = 0.0

    static let sortDealOriginXFactor: CGFloat = 0.5
    static let sortDealOriginYFactor: CGFloat = 0.18

    static let sortDealMaxRotationDegrees: Double = 6

    static let sortDragSnapBackDuration: Double = 0.12

    static var sortDealAnimation: Animation {
        .spring(response: 0.26, dampingFraction: 0.86, blendDuration: 0.04)
    }
}
