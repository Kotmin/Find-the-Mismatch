//
//  GameMode.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

enum GameMode: String, CaseIterable, Codable, Hashable, Identifiable {
    var id: String { rawValue }
    case findMismatch
    case sortCards
}

