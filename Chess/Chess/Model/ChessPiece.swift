//
//  ChessPiece.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import Foundation
import UIKit

enum ChessColor {
    case white
    case black
}

protocol ChessPiece {
    var color: ChessColor { get }
    var initialPosition: ChessSquare { get }
    var position: ChessSquare { get set }
    var possiblePositions: [ChessSquare] { get }
    var image: UIImage { get }
    mutating func move(to position: ChessSquare)
}

struct Pawn: ChessPiece {
    let color: ChessColor
    let initialPosition: ChessSquare
    let image: UIImage
    var position: ChessSquare
    var possiblePositions: [ChessSquare] {
        get {
            let oneStepMoves = [1, -1]
            
            var possiblePositions: [ChessSquare] = []
            for move in oneStepMoves {
                possiblePositions.append(ChessSquare(x: position.x + move, y: position.y))
                possiblePositions.append(ChessSquare(x: position.x, y: position.y + move))
            }
            
            if position == initialPosition {
                possiblePositions.append(ChessSquare(x: position.x, y: position.y + 2))
            }
            
            return possiblePositions
        }
    }
    
    mutating func move(to position: ChessSquare) {
        self.position = position
    }
    
    init(color: ChessColor, initialPosition: ChessSquare) {
        self.color = color
        self.initialPosition = initialPosition
        self.position = initialPosition
        switch color {
        case .white:
            self.image = UIImage(named: "pawnWhite")!
        case .black:
            self.image = UIImage(named: "pawnBlack")!
        }
    }
}

struct Rook: ChessPiece {
    let color: ChessColor
    let initialPosition: ChessSquare
    let image: UIImage
    var position: ChessSquare
    var possiblePositions: [ChessSquare] {
        get {
            let moves = [-1, -2, -3, -4, -5, -6, -7, 1, 2, 3, 4, 5, 6, 7]
            
            var possiblePositions: [ChessSquare] = []
            for move in moves {
                possiblePositions.append(ChessSquare(x: position.x + move, y: position.y))
                possiblePositions.append(ChessSquare(x: position.x, y: position.y + move))
            }
            
            return possiblePositions
        }
    }
    
    init(color: ChessColor, initialPosition: ChessSquare) {
        self.color = color
        self.initialPosition = initialPosition
        self.position = initialPosition
        switch color {
        case .white:
            self.image = UIImage(named: "rookWhite")!
        case .black:
            self.image = UIImage(named: "rookBlack")!
        }
    }
    
    mutating func move(to position: ChessSquare) {
        self.position = position
    }
}

struct Bishop: ChessPiece {
    let color: ChessColor
    let initialPosition: ChessSquare
    let image: UIImage
    var position: ChessSquare
    var possiblePositions: [ChessSquare] {
        get {
            let moves = [1, 2, 3, 4, 5, 6, 7]
                        
            var possiblePositions: [ChessSquare] = []
            for i in 0..<moves.count {
                possiblePositions.append(ChessSquare(x: position.x + moves[i], y: position.y + moves[i]))
                possiblePositions.append(ChessSquare(x: position.x - moves[i], y: position.y - moves[i]))
                possiblePositions.append(ChessSquare(x: position.x - moves[i], y: position.y + moves[i]))
                possiblePositions.append(ChessSquare(x:position.x + moves[i], y: position.y - moves[i]))
            }

            return possiblePositions
        }
    }
    
    init(color: ChessColor, initialPosition: ChessSquare) {
        self.color = color
        self.initialPosition = initialPosition
        self.position = initialPosition
        switch color {
        case .white:
            self.image = UIImage(named: "bishopWhite")!
        case .black:
            self.image = UIImage(named: "bishopBlack")!
        }
    }
    
    mutating func move(to position: ChessSquare) {
        self.position = position
    }
}

struct Knight: ChessPiece {
    let color: ChessColor
    let initialPosition: ChessSquare
    let image: UIImage
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
    
    init(color: ChessColor, initialPosition: ChessSquare) {
        self.color = color
        self.initialPosition = initialPosition
        self.position = initialPosition
        switch color {
        case .white:
            self.image = UIImage(named: "knightWhite")!
        case .black:
            self.image = UIImage(named: "knightBlack")!
        }
    }
    
    mutating func move(to position: ChessSquare) {
        self.position = position
    }
}

struct Queen: ChessPiece {
    let color: ChessColor
    let initialPosition: ChessSquare
    let image: UIImage
    var position: ChessSquare
    var possiblePositions: [ChessSquare] {
        get {
            let moves = [1, 2, 3, 4, 5, 6, 7]
            var possiblePositions: [ChessSquare] = []
            
            for x in moves {
                possiblePositions.append(ChessSquare(x: position.x + x, y: position.y))
                possiblePositions.append(ChessSquare(x: position.x - x, y: position.y))
                possiblePositions.append(ChessSquare(x: position.x, y: position.y + x))
                possiblePositions.append(ChessSquare(x: position.x, y: position.y - x))
                possiblePositions.append(ChessSquare(x: position.x + x, y: position.y + x))
                possiblePositions.append(ChessSquare(x: position.x - x, y: position.y - x))
                possiblePositions.append(ChessSquare(x: position.x + x, y: position.y - x))
                possiblePositions.append(ChessSquare(x: position.x - x, y: position.y + x))
            }

            return possiblePositions
        }
    }
    
    init(color: ChessColor, initialPosition: ChessSquare) {
        self.color = color
        self.initialPosition = initialPosition
        self.position = initialPosition
        switch color {
        case .white:
            self.image = UIImage(named: "queenWhite")!
        case .black:
            self.image = UIImage(named: "queenBlack")!
        }
    }
    
    mutating func move(to position: ChessSquare) {
        self.position = position
    }
}

struct King: ChessPiece {
    let color: ChessColor
    let initialPosition: ChessSquare
    let image: UIImage
    var position: ChessSquare
    var possiblePositions: [ChessSquare] {
        get {
            var possiblePositions: [ChessSquare] = []
            
                possiblePositions.append(ChessSquare(x: position.x + 1, y: position.y))
                possiblePositions.append(ChessSquare(x: position.x - 1, y: position.y))
                possiblePositions.append(ChessSquare(x: position.x, y: position.y + 1))
                possiblePositions.append(ChessSquare(x: position.x, y: position.y - 1))
                possiblePositions.append(ChessSquare(x: position.x + 1, y: position.y + 1))
                possiblePositions.append(ChessSquare(x: position.x - 1, y: position.y - 1))
                possiblePositions.append(ChessSquare(x: position.x + 1, y: position.y - 1))
                possiblePositions.append(ChessSquare(x: position.x - 1, y: position.y + 1))

            return possiblePositions
        }
    }
    
    init(color: ChessColor, initialPosition: ChessSquare) {
        self.color = color
        self.initialPosition = initialPosition
        self.position = initialPosition
        switch color {
        case .white:
            self.image = UIImage(named: "kingWhite")!
        case .black:
            self.image = UIImage(named: "kingBlack")!
        }
    }
    
    mutating func move(to position: ChessSquare) {
        self.position = position
    }
}
