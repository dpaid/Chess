//
//  ChessBoardView.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import UIKit

class ChessBoardView: UIView {
    static let margin: CGFloat = 30
    let chessBoard: ChessBoard
    
    init(chessBoard: ChessBoard) {
        self.chessBoard = chessBoard
        super.init(frame: .zero)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let squareSize = (bounds.width - ChessBoardView.margin) / sqrt(CGFloat(chessBoard.squares.count))
        drawSquares(squareSize: squareSize)
        drawLetters(squareSize: squareSize)
        drawNumbers(squareSize: squareSize)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        print(location)
    }
}

extension ChessBoardView {
    private func drawSquares(squareSize: CGFloat) {
        chessBoard.squares.forEach { square in
            if (square.row + square.column) % 2 == 0 {
                let path = UIBezierPath(rect: CGRect(x: (CGFloat(square.row) * squareSize + ChessBoardView.margin),
                                                     y: CGFloat(square.column) * squareSize,
                                                     width: squareSize,
                                                     height: squareSize))
            
                UIColor.black.setFill()
                path.fill()
            }
        }
    }
    
    private func drawLetters(squareSize: CGFloat) {
        let allLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W"]
        let letters = allLetters.prefix(chessBoard.size)
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                          NSAttributedString.Key.foregroundColor : UIColor.black]
        let charSize = 15
        
        for (index, letter) in letters.enumerated() {
            letter.draw(with: CGRect(x: ((CGFloat(index) * squareSize) + (squareSize / 2) + (ChessBoardView.margin - CGFloat(charSize) / 4)),
                                     y: squareSize * CGFloat(chessBoard.size) + ChessBoardView.margin,
                                     width: CGFloat(charSize),
                                     height: CGFloat(charSize)),
                        options: .usesDeviceMetrics,
                        attributes: attributes,
                        context: nil)
        }
    }
    
    private func drawNumbers(squareSize: CGFloat) {
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                          NSAttributedString.Key.foregroundColor : UIColor.black]
        let numberSize = 15
        
        for number in 1...chessBoard.size {
            "\(number)".draw(with: CGRect(x: ChessBoardView.margin / 4,
                                          y: (CGFloat(chessBoard.size - number) * squareSize + (squareSize / 2) + ChessBoardView.margin / 4),
                                          width: CGFloat(numberSize),
                                          height: CGFloat(numberSize)),
                             options: .usesDeviceMetrics,
                             attributes: attributes,
                             context: nil)
        }
    }
}
