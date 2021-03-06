//
//  ChessPiece.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import Foundation

enum ChessColor {
    case white
    case black
}

protocol ChessPiece {
    var color: ChessColor { get }
    var initialPosition: ChessSquare { get }
    var position: ChessSquare { get set }
    var possiblePositions: [ChessSquare] { get }
    mutating func move(to position: ChessSquare)
}

struct Knight: ChessPiece {
    let color: ChessColor
    let initialPosition: ChessSquare
    var position: ChessSquare
    var possiblePositions: [ChessSquare] {
        get {
            let oneStepMoves = [1, -1]
            let twoStepMoves = [2, -2]
            
            var possiblePositions: [ChessSquare] = []
            for row in oneStepMoves {
                for column in twoStepMoves {
                    possiblePositions.append(ChessSquare(x: position.x + row, y: position.y + column))
                }
            }
            for row in twoStepMoves {
                for column in oneStepMoves {
                    possiblePositions.append(ChessSquare(x: position.x + row, y: position.y + column))
                }
            }
            
            return possiblePositions
        }
    }
    
    mutating func move(to position: ChessSquare) {
        self.position = position
    }
}
