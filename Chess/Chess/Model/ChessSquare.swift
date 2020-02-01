//
//  ChessSquare.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import Foundation

struct ChessSquare: Equatable, Hashable {
    let x: Int
    let y: Int
}

extension ChessSquare: CustomStringConvertible {
    var description: String {
        let allLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W"]
        return "\(allLetters[x])\(y+1)"
    }
}
