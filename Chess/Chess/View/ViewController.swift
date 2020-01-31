//
//  ViewController.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var chessBoardView: ChessBoardView
    
    init() {
        self.chessBoardView = ChessBoardView()
        super.init(nibName: nil, bundle: nil)
        
        title = "Say Cheesse"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Resize", style: .plain, target: self, action: #selector(didPressResize(_:)))
        setupBoardView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressResize(_ sender: UIBarButtonItem) {
        let sizesAlertController = UIAlertController(title: "Pick board size", message: nil, preferredStyle: .alert)
        for size in ChessBoard.validSizes {
            let action = UIAlertAction(title: "\(size) x \(size)", style: .default) { (action) in
                self.chessBoardView.resize(size: size)
            }
            sizesAlertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        sizesAlertController.addAction(cancelAction)
        
        present(sizesAlertController, animated: true, completion: nil)
    }

    
    private func setupBoardView() {
        chessBoardView.contentMode = .redraw
        chessBoardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chessBoardView)
        chessBoardView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        chessBoardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        chessBoardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        chessBoardView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
}

