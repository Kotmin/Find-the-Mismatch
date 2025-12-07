//
//  Category+DisplayName.swift
//  Find the Mismatch
//
//  Created by Paweł Jan Tłusty on 07/12/2025.
//

import Foundation

extension Category {
    var displayName: String {
        let name = String(describing: self)
        guard let first = name.first else { return name }
        return String(first).uppercased() + name.dropFirst()
    }
}

