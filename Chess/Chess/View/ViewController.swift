//
//  ViewController.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var boardView: ChessBoardView
    
    init(board: ChessBoard) {
        self.boardView = ChessBoardView(chessBoard: board)
        super.init(nibName: nil, bundle: nil)
        
        title = "Say Cheesse"
        view.backgroundColor = .white
        setupBoardView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBoardView() {
        boardView.contentMode = .redraw
        boardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardView)
        boardView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        boardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        boardView.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}

