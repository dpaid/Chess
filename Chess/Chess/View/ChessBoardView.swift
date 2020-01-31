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
    private var chessBoard: ChessBoard
    private var squareSize: CGFloat {
        return (bounds.width - ChessBoardView.margin) / sqrt(CGFloat(chessBoard.squares.count))
    }
    
    
    init() {
        self.chessBoard = ChessBoard(size: 8)
        super.init(frame: .zero)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawSquares()
        drawLetters()
        drawNumbers()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let point = touch.location(in: self)
        
        guard let square = chessBoard.translate(point: point, in: self) else { return }
        chessBoard.moveToNextState(square: square)
        setNeedsDisplay()
    }
    
    func resize(size: Int) {
        self.chessBoard = ChessBoard(size: size)
        setNeedsDisplay()
    }
}

extension ChessBoardView {
    private func drawSquares() {
        chessBoard.squares.forEach { square in
            let color = chessBoard.color(for: square)
            let path = UIBezierPath(rect: CGRect(x: (CGFloat(square.x) * squareSize + ChessBoardView.margin),
                                                 y: CGFloat(chessBoard.size - 1 - square.y) * squareSize,
                                                 width: squareSize,
                                                 height: squareSize))
            
            color.setFill()
            path.fill()
        }
    }
    
    private func drawLetters() {
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
    
    private func drawNumbers() {
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
