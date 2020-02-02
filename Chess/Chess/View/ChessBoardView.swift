//
//  ChessBoardView.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import UIKit

protocol ChessBoardViewDelegate: class {
    func didStartFindingPaths()
    func didFind(paths: [Stack<ChessSquare>])
    func clearPaths()
}

class ChessBoardView: UIView {
    static let margin: CGFloat = 30
    private var chessBoard: ChessBoard
    private var squareSize: CGFloat {
        return (bounds.width - ChessBoardView.margin) / sqrt(CGFloat(chessBoard.squares.count))
    }
    weak var delegate: ChessBoardViewDelegate?
    
    init(chessBoard: ChessBoard = ChessBoard(size: 8)) {
        self.chessBoard = chessBoard
        super.init(frame: .zero)
        backgroundColor = UIColor.systemBackground
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
        
        let newState = chessBoard.moveToNextState(square: square)
        switch newState {
        case .initial:
            delegate?.clearPaths()
        case .incomplete:
            break
        case .complete(let start, let end):
            delegate?.didStartFindingPaths()
            let knight: ChessPiece = Knight(color: .white, initialPosition: ChessSquare(x: 1, y: 0), position: start)
            chessBoard.findPaths(piece: knight, start: start, end: end) { [weak self] solutions in
                self?.delegate?.didFind(paths: solutions)
            }
        }
        
        setNeedsDisplay()
    }
    
    func resize(size: Int) {
        chessBoard.cancelFindPathsTask()
        chessBoard = ChessBoard(size: size)
        delegate?.clearPaths()
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
        let letters = ChessBoard.allLetters.prefix(chessBoard.size)
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
                          NSAttributedString.Key.foregroundColor : UIColor.label]
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
                          NSAttributedString.Key.foregroundColor : UIColor.label]
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
