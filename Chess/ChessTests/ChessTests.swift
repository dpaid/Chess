//
//  ChessTests.swift
//  ChessTests
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import XCTest
@testable import Chess

class ChessTests: XCTestCase {
    
    func testChessPieceMoveToPosition() {
        // Given
        var piece = Knight(color: .black, initialPosition: ChessSquare(x: 1, y: 0), position: ChessSquare(x: 0, y: 1))
        
        // When
        let endSquare = ChessSquare(x: 2, y: 2)
        piece.move(to: endSquare)
        
        // Then
        XCTAssertEqual(piece.position, endSquare)
    }
    
    func testChessBoardStateMoveToNextStateFromInitial() {
        // Given
        var chessboardState = ChessBoardState.initial
        let startSquare1 = ChessSquare(x: 1, y: 0)
        
        // When
        _ = chessboardState.moveToNextState(square: startSquare1)
        
        // Then
        XCTAssertEqual(chessboardState, ChessBoardState.incomplete(start: startSquare1))
    }
    
    func testChessBoardStateMoveToNextStateFromIncomplete() {
        // Given
        let startSquare = ChessSquare(x: 1, y: 0)
        var chessboardState = ChessBoardState.incomplete(start: startSquare)
        let endSquare = ChessSquare(x: 2, y: 2)
        
        // When
        _ = chessboardState.moveToNextState(square: endSquare)
        
        // Then
        XCTAssertEqual(chessboardState, ChessBoardState.complete(start: startSquare, end: endSquare))
    }
    
    func testChessBoardStateMoveToNextStateFromComplete() {
        // Given
        let startSquare = ChessSquare(x: 0, y: 2)
        let endSquare = ChessSquare(x: 2, y: 2)
        let square = ChessSquare(x: 2, y: 3)
        var chessboardState = ChessBoardState.complete(start: startSquare, end: endSquare)
        
        // When
        _ = chessboardState.moveToNextState(square: square)
        
        // Then
        XCTAssertEqual(chessboardState, ChessBoardState.initial)

    }
    
    func testFindPathsEmptyResults() {
        // Given
        var chessBoard = ChessBoard(size: 8)
        let start = ChessSquare(x: 0, y: 0)
        let end = ChessSquare(x: 7, y: 7)
        let knight: ChessPiece = Knight(color: .white, initialPosition: ChessSquare(x: 1, y: 0), position: start)
        
        let expectation = self.expectation(description: "Solving")
        var paths: [Stack<ChessSquare>]?
        
        // When
        chessBoard.findPaths(piece: knight, start: start, end: end) {
            paths = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        // Then
        XCTAssertEqual(paths, [])
    }
    
    func testFindPathsWithResults() {
        // Given
        var chessBoard = ChessBoard(size: 8)
        let start = ChessSquare(x: 0, y: 0)
        let end = ChessSquare(x: 3, y: 3)
        let knight: ChessPiece = Knight(color: .white, initialPosition: ChessSquare(x: 1, y: 0), position: start)
        
        let expectation = self.expectation(description: "Solving")
        var paths: [Stack<ChessSquare>]?

        // When
        chessBoard.findPaths(piece: knight, start: start, end: end) {
            paths = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)

        // Then
        XCTAssertEqual(paths?.count, 2)

        var stack1 = Stack<ChessSquare>()
        stack1.push(start)
        stack1.push(ChessSquare(x: 2, y: 1))
        stack1.push(ChessSquare(x: 3, y: 3))

        var stack2 = Stack<ChessSquare>()
        stack2.push(start)
        stack2.push(ChessSquare(x: 1, y: 2))
        stack2.push(ChessSquare(x: 3, y: 3))

        XCTAssert(paths?.contains(stack1) ?? false)
        XCTAssert(paths?.contains(stack2) ?? false)
    }
}

