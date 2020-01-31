//
//  ChessBoard.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import Foundation
import UIKit

struct ChessBoard {
    static let validSizes = 6...16
    private var state: ChessBoardState = .initial
    let size: Int
    var squares: [ChessSquare] = []
    
    init(size: Int) {
        self.size = size
        for x in 0..<size {
            for y in 0..<size {
                self.squares.append(ChessSquare(x: x, y: y))
            }
        }
    }
    
    func validPositions(piece: ChessPiece) -> Set<ChessSquare> {
        var validPositions: Set<ChessSquare> = []
        for position in piece.possiblePositions {
            guard position.x >= 0 && position.x < size,
                position.y >= 0 && position.y < size else { continue }
            validPositions.insert(position)
        }
        return validPositions
    }
    
    func translate(point: CGPoint, `in` view: ChessBoardView) -> ChessSquare? {
        guard point.x > ChessBoardView.margin,
            point.x < view.bounds.width,
            point.y > 0 ,
            point.y < view.bounds.height - ChessBoardView.margin else { return nil }
        
        let squareSize = (view.bounds.width - ChessBoardView.margin) / sqrt(CGFloat(squares.count))
        let x = Int((point.x - ChessBoardView.margin) / squareSize)
        let y = Int((view.bounds.height - ChessBoardView.margin - point.y) / squareSize)
        
        print("x: \(x), y: \(y), squareSize: \(squareSize)")
        return ChessSquare(x: x, y: y)
    }
    
    mutating func moveToNextState(square: ChessSquare) {
        state.moveToNextState(square: square)
    }
    
    func defineColor(square: ChessSquare) -> UIColor {
        switch state {
        case .initial:
            return (square.x + square.y) % 2 == 0 ? .black : .white
        case .incomplete(let start):
            return square == start ? .green : ((square.x + square.y) % 2 == 0 ? .black : .white)
        case .complete(let start, let end):
            return square == start ? .green : (square == end) ? .red : ((square.x + square.y) % 2 == 0 ? .black : .white)
        }
    }
}
