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

    func testChessBoardValidPositions() {
        // Given
        let chessBoard = ChessBoard(size: 8)
        let piece = Knight(color: .black, initialPosition: ChessSquare(x: 0, y: 1), position: ChessSquare(x: 0, y: 1))
        
        // When
        let validPositions = chessBoard.validPositions(piece: piece)
        
        // Then
        XCTAssertEqual(chessBoard.validPositions(piece: piece).count, 3)
        XCTAssert(validPositions.contains(ChessSquare(x: 2, y: 0)))
        XCTAssert(validPositions.contains(ChessSquare(x: 2, y: 2)))
        XCTAssert(validPositions.contains(ChessSquare(x: 1, y: 3)))
        
        // Given
        let piece2 = Knight(color: .black, initialPosition: ChessSquare(x: 0, y: 1), position: ChessSquare(x: 3, y: 3))
           
        // When
        let validPositions2 = chessBoard.validPositions(piece: piece2)
           
        // Then
        XCTAssertEqual(chessBoard.validPositions(piece: piece2).count, 8)
        XCTAssert(validPositions2.contains(ChessSquare(x: 4, y: 5)))
        XCTAssert(validPositions2.contains(ChessSquare(x: 4, y: 1)))
        XCTAssert(validPositions2.contains(ChessSquare(x: 2, y: 5)))
        XCTAssert(validPositions2.contains(ChessSquare(x: 2, y: 1)))
        XCTAssert(validPositions2.contains(ChessSquare(x: 5, y: 2)))
        XCTAssert(validPositions2.contains(ChessSquare(x: 5, y: 4)))
        XCTAssert(validPositions2.contains(ChessSquare(x: 1, y: 2)))
        XCTAssert(validPositions2.contains(ChessSquare(x: 1, y: 4)))
    }

    func testChessPieceMoveToPosition() {
        // Given
        var piece = Knight(color: .black, initialPosition: ChessSquare(x: 0, y: 1), position: ChessSquare(x: 0, y: 1))
        
        // When
        let endSquare = ChessSquare(x: 2, y: 2)
        piece.move(to: endSquare)
        
        // Then
        XCTAssertEqual(piece.position, endSquare)
    }
    
    func testChessBoardStateMoveToNextState() {
        // Given
        var chessboardState = ChessBoardState.initial
        let startSquare1 = ChessSquare(x: 0, y: 1)
        
        // When
        _ = chessboardState.moveToNextState(square: startSquare1)
        
        // Then
        XCTAssertEqual(chessboardState, ChessBoardState.incomplete(start: startSquare1))
        
        // Given
        let startSquare2 = ChessSquare(x: 0, y: 1)
        var chessboardState2 = ChessBoardState.incomplete(start: startSquare2)
        let endSquare2 = ChessSquare(x: 2, y: 2)
        
        
        // When
        _ = chessboardState2.moveToNextState(square: endSquare2)
        
        // Then
        XCTAssertEqual(chessboardState2, ChessBoardState.complete(start: startSquare2, end: endSquare2))
        
        // Given
        let startSquare3 = ChessSquare(x: 0, y: 2)
        let endSquare3 = ChessSquare(x: 2, y: 2)
        let square = ChessSquare(x: 2, y: 3)
        var chessboardState3 = ChessBoardState.complete(start: startSquare3, end: endSquare3)
        
        // When
        _ = chessboardState3.moveToNextState(square: square)
        
        // Then
        XCTAssertEqual(chessboardState3, ChessBoardState.initial)
    }
}

