//
//  BoardState.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import Foundation

enum ChessBoardState {
    case initial
    case incomplete(start: ChessSquare)
    case complete(start: ChessSquare, end: ChessSquare)
    
    mutating func moveToNextState(square: ChessSquare) {
        switch (self) {
        case .initial:
            self = .incomplete(start: square)
        case .incomplete(let start):
            if start == square {
                self = .initial
            } else {
                self = .complete(start: start, end: square)
            }
        case (.complete):
            self = .initial
        }
    }
}
