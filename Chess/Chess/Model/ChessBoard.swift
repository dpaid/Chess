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
    static let allLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W"]
    private var state: ChessBoardState = .initial
    private var findPathsTask: DispatchWorkItem?
    let size: Int
    var squares: [ChessSquare] = []
    var pieces: [ChessPiece] = [Pawn(color: .white, initialPosition: ChessSquare(x: 0, y: 1)),
                               Pawn(color: .white, initialPosition: ChessSquare(x: 1, y: 1)),
                               Pawn(color: .white, initialPosition: ChessSquare(x: 2, y: 1)),
                               Pawn(color: .white, initialPosition: ChessSquare(x: 3, y: 1)),
                               Pawn(color: .white, initialPosition: ChessSquare(x: 4, y: 1)),
                               Pawn(color: .white, initialPosition: ChessSquare(x: 5, y: 1)),
                               Pawn(color: .white, initialPosition: ChessSquare(x: 6, y: 1)),
                               Pawn(color: .white, initialPosition: ChessSquare(x: 7, y: 1)),
                               Rook(color: .white, initialPosition: ChessSquare(x: 0, y: 0)),
                               Rook(color: .white, initialPosition: ChessSquare(x: 7, y: 0)),
                               Bishop(color: .white, initialPosition: ChessSquare(x: 1, y: 0)),
                               Bishop(color: .white, initialPosition: ChessSquare(x: 6, y: 0)),
                               Knight(color: .white,
                                       initialPosition: ChessSquare(x: 2, y: 0)),
                               Knight(color: .white,
                                       initialPosition: ChessSquare(x: 5, y: 0)),
                               Queen(color: .white, initialPosition: ChessSquare(x: 3, y: 0)),
                               King(color: .white, initialPosition: ChessSquare(x: 4, y: 0)),
                               Pawn(color: .black, initialPosition: ChessSquare(x: 0, y: 6)),
                               Pawn(color: .black, initialPosition: ChessSquare(x: 1, y: 6)),
                               Pawn(color: .black, initialPosition: ChessSquare(x: 2, y: 6)),
                               Pawn(color: .black, initialPosition: ChessSquare(x: 3, y: 6)),
                               Pawn(color: .black, initialPosition: ChessSquare(x: 4, y: 6)),
                               Pawn(color: .black, initialPosition: ChessSquare(x: 5, y: 6)),
                               Pawn(color: .black, initialPosition: ChessSquare(x: 6, y: 6)),
                               Pawn(color: .black, initialPosition: ChessSquare(x: 7, y: 6)),
                               Rook(color: .black, initialPosition: ChessSquare(x: 0, y: 7)),
                               Rook(color: .black, initialPosition: ChessSquare(x: 7, y: 7)),
                               Bishop(color: .black, initialPosition: ChessSquare(x: 1, y: 7)),
                               Bishop(color: .black, initialPosition: ChessSquare(x: 6, y: 7)),
                               Knight(color: .black,
                                       initialPosition: ChessSquare(x: 2, y: 7)),
                               Knight(color: .black,
                                       initialPosition: ChessSquare(x: 5, y: 7)),
                               Queen(color: .black, initialPosition: ChessSquare(x: 3, y: 7)),
                               King(color: .black, initialPosition: ChessSquare(x: 4, y: 7))
    ]
    
    init(size: Int) {
        self.size = size
        for x in 0..<size {
            for y in 0..<size {
                self.squares.append(ChessSquare(x: x, y: y))
            }
        }
    }
    
    func translate(point: CGPoint, `in` view: ChessBoardView) -> ChessSquare? {
        guard point.x > view.margin,
            point.x < view.bounds.width,
            point.y > 0 ,
            point.y < view.bounds.height - view.margin else { return nil }
        
        let squareSize = (view.bounds.width - view.margin) / sqrt(CGFloat(squares.count))
        let x = Int((point.x - view.margin) / squareSize)
        let y = Int((view.bounds.height - view.margin - point.y) / squareSize)
        
        return ChessSquare(x: x, y: y)
    }
    
    mutating func moveToNextState(square: ChessSquare) -> ChessBoardState {
        return state.moveToNextState(square: square)
    }
    
    mutating func findPaths(piece: ChessPiece,
                            start: ChessSquare,
                            end: ChessSquare,
                            completion: @escaping ([Stack<ChessSquare>]) -> Void) {
        var task: DispatchWorkItem?
        task = DispatchWorkItem { [self] in
            var chessPiece: ChessPiece = piece
            chessPiece.position = start
            var visitedStack = Stack<ChessSquare>()
            let paths = self.depthFirstSearch(piece: &chessPiece, visitedStack: &visitedStack, start: start, end: end)
            let sortedPaths = paths.sorted { $0.description.count < $1.description.count }
            if !(task?.isCancelled ?? true) {
                DispatchQueue.main.async {
                    completion(sortedPaths)
                }
            }
        }
        self.findPathsTask = task
        DispatchQueue.global(qos: .background).async(execute: self.findPathsTask!)
    }
    
    func cancelFindPathsTask() {
        findPathsTask?.cancel()
    }
    
    func squareSize(`for` view: ChessBoardView) -> CGFloat {
        return (view.bounds.width - view.margin) / sqrt(CGFloat(squares.count))
    }
    
    func color(`for` square: ChessSquare) -> UIColor {
        switch state {
        case .initial:
            return (square.x + square.y) % 2 == 0 ? UIColor.white : UIColor.lightGray
        case .incomplete(let start):
            return square == start ? .green : ((square.x + square.y) % 2 == 0 ? UIColor.white : UIColor.lightGray)
        case .complete(let start, let end):
            return square == start ? .green : (square == end) ? .red : ((square.x + square.y) % 2 == 0 ? UIColor.white : UIColor.lightGray)
        }
    }
}

extension ChessBoard {
    private func depthFirstSearch(piece: inout ChessPiece,
                                  visitedStack: inout Stack<ChessSquare>,
                                  start: ChessSquare,
                                  end: ChessSquare,
                                  cutoff: Int? = 3) -> [Stack<ChessSquare>] {
        var paths: [Stack<ChessSquare>] = []
        
        visitedStack.push(start)
        for position in validPositions(piece: piece) {
            guard cutoff == nil || cutoff! > 0 else { return paths }
            
            guard !visitedStack.contains(element: position) else { continue }
            piece.move(to: position)
            if position == end {
                visitedStack.push(position)
                paths.append(visitedStack)
            } else {
                paths += depthFirstSearch(piece: &piece, visitedStack: &visitedStack, start: position, end: end, cutoff: cutoff == nil ? cutoff : cutoff! - 1)
            }
            _ = visitedStack.pop()
        }
        return paths
    }
    
    private func validPositions(piece: ChessPiece) -> [ChessSquare] {
        var validPositions: [ChessSquare] = []
        for position in piece.possiblePositions {
            guard position.x >= 0 && position.x < size,
                position.y >= 0 && position.y < size else { continue }
            validPositions.append(position)
        }
        return validPositions
    }
}
