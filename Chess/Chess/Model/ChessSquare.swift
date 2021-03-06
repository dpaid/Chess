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
        return "\(ChessBoard.allLetters[x])\(y+1)"
    }
}
