//
//  ChessBoard.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import Foundation

struct ChessBoard {
    let size: Int
    var squares: [ChessSquare]
    
    init(size: Int) {
        self.size = size
        self.squares = []
        
        for row in 0..<size {
            for column in 0..<size {
                self.squares.append(ChessSquare(row: row, column: column))
            }
        }
    }
    
    func validPositions(piece: ChessPiece) -> Set<ChessSquare> {
        var validPositions: Set<ChessSquare> = []
        for position in piece.possiblePositions {
            guard position.row >= 0 && position.row < size,
                position.column >= 0 && position.column < size else { continue }
            validPositions.insert(position)
        }
        return validPositions
    }
}
