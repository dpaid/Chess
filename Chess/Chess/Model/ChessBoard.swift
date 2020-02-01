//
//  ChessBoard.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import Foundation
import UIKit

protocol ChessBoardDelegate: class {
    func didStartFindingPaths()
    func didFind(paths: [Stack<ChessSquare>])
    func shouldClearPaths()
}

struct ChessBoard {
    static let validSizes = 6...16
    private var state: ChessBoardState = .initial
    private var findPathsTask: DispatchWorkItem?
    let size: Int
    var squares: [ChessSquare] = []
    weak var delegate: ChessBoardDelegate?
    
    init(size: Int) {
        self.size = size
        for x in 0..<size {
            for y in 0..<size {
                self.squares.append(ChessSquare(x: x, y: y))
            }
        }
    }
    
    func translate(point: CGPoint, `in` view: ChessBoardView) -> ChessSquare? {
        guard point.x > ChessBoardView.margin,
            point.x < view.bounds.width,
            point.y > 0 ,
            point.y < view.bounds.height - ChessBoardView.margin else { return nil }
        
        let squareSize = (view.bounds.width - ChessBoardView.margin) / sqrt(CGFloat(squares.count))
        let x = Int((point.x - ChessBoardView.margin) / squareSize)
        let y = Int((view.bounds.height - ChessBoardView.margin - point.y) / squareSize)
        
        return ChessSquare(x: x, y: y)
    }
    
    mutating func moveToNextState(square: ChessSquare) {
        delegate?.shouldClearPaths()
        findPathsTask?.cancel()
        let newState = state.moveToNextState(square: square)
        switch newState {
        case .initial:
            delegate?.shouldClearPaths()
        case .incomplete:
            break
        case .complete(let start, let end):
            self.delegate?.didStartFindingPaths()
            startFindingPaths(start: start, end: end)
        }
    }
    
    private mutating func startFindingPaths(start: ChessSquare, end: ChessSquare) {
        var task: DispatchWorkItem?
        task = DispatchWorkItem { [self] in
            var knight: ChessPiece = Knight(color: .white, initialPosition: ChessSquare(x: 1, y: 0), position: start)
            var visitedStack = Stack<ChessSquare>()
            let solutions = self.depthFirstSearch(piece: &knight, visitedStack: &visitedStack, start: start, end: end)
            let sortedSolutions = solutions.sorted { $0.description.count < $1.description.count }
            if !(task?.isCancelled ?? false) {
                DispatchQueue.main.async {
                    self.delegate?.didFind(paths: sortedSolutions)
                }
            }
        }
        self.findPathsTask = task
        DispatchQueue.global(qos: .background).async(execute: self.findPathsTask!)
    }
    
    func color(`for` square: ChessSquare) -> UIColor {
        switch state {
        case .initial:
            return (square.x + square.y) % 2 == 0 ? UIColor.systemBackground : UIColor.label
        case .incomplete(let start):
            return square == start ? .green : ((square.x + square.y) % 2 == 0 ? UIColor.systemBackground : UIColor.label)
        case .complete(let start, let end):
            return square == start ? .green : (square == end) ? .red : ((square.x + square.y) % 2 == 0 ? UIColor.systemBackground : UIColor.label)
        }
    }
}

extension ChessBoard {
    private func depthFirstSearch(piece: inout ChessPiece,
                          visitedStack: inout Stack<ChessSquare>,
                          start: ChessSquare,
                          end: ChessSquare,
                          cutoff: Int? = 3) -> [Stack<ChessSquare>] {
        var solutions: [Stack<ChessSquare>] = []
        
        visitedStack.push(start)
        for position in validPositions(piece: piece) {
            guard cutoff == nil || cutoff! > 0 else { return solutions }
            
            guard !visitedStack.contains(element: position) else { continue }
            piece.move(to: position)
            if position == end {
                visitedStack.push(position)
                solutions.append(visitedStack)
            } else {
                solutions += depthFirstSearch(piece: &piece, visitedStack: &visitedStack, start: position, end: end, cutoff: cutoff == nil ? cutoff : cutoff! - 1)
            }
            _ = visitedStack.pop()
        }
        return solutions
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
}
