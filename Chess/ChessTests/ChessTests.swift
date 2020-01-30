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

    func testValidPositions() {
        // Given
        let chessBoard = ChessBoard(size: 8)
        let piece = Knight(color: .black, initialPosition: ChessSquare(row: 0, column: 1), position: ChessSquare(row: 0, column: 1))
        
        // When
        let validPositions = chessBoard.validPositions(piece: piece)
        
        // Then
        XCTAssertEqual(chessBoard.validPositions(piece: piece).count, 3)
        XCTAssert(validPositions.contains(ChessSquare(row: 2, column: 0)))
        XCTAssert(validPositions.contains(ChessSquare(row: 2, column: 2)))
        XCTAssert(validPositions.contains(ChessSquare(row: 1, column: 3)))
        
        // Given
        let piece2 = Knight(color: .black, initialPosition: ChessSquare(row: 0, column: 1), position: ChessSquare(row: 3, column: 3))
           
        // When
        let validPositions2 = chessBoard.validPositions(piece: piece2)
           
        // Then
        XCTAssertEqual(chessBoard.validPositions(piece: piece2).count, 8)
        XCTAssert(validPositions2.contains(ChessSquare(row: 4, column: 5)))
        XCTAssert(validPositions2.contains(ChessSquare(row: 4, column: 1)))
        XCTAssert(validPositions2.contains(ChessSquare(row: 2, column: 5)))
        XCTAssert(validPositions2.contains(ChessSquare(row: 2, column: 1)))
        XCTAssert(validPositions2.contains(ChessSquare(row: 5, column: 2)))
        XCTAssert(validPositions2.contains(ChessSquare(row: 5, column: 4)))
        XCTAssert(validPositions2.contains(ChessSquare(row: 1, column: 2)))
        XCTAssert(validPositions2.contains(ChessSquare(row: 1, column: 4)))
    }

}

