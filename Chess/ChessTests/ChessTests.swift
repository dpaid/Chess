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

}

