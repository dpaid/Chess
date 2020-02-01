//
//  ViewController.swift
//  Chess
//
//  Created by dimitris paidarakis on 30/1/20.
//  Copyright © 2020 dimitris paidarakis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let chessBoardView = ChessBoardView()
    private let tableView = UITableView()
    private var paths: [Stack<ChessSquare>] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Say Cheesse"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Resize", style: .plain, target: self, action: #selector(didPressResize(_:)))
        setupBoardView()
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressResize(_ sender: UIBarButtonItem) {
        var actions: [UIAlertAction] = []
        for size in ChessBoard.validSizes {
            let action = UIAlertAction(title: "\(size) x \(size)", style: .default) { [weak self] (action) in
                self?.paths = []
                self?.chessBoardView.resize(size: size)
            }
            actions.append(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actions.append(cancelAction)
        presentAlert(title: "Pick board size", message: nil, actions: actions)
    }

    
    private func setupBoardView() {
        chessBoardView.delegate = self
        chessBoardView.contentMode = .redraw
        chessBoardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chessBoardView)
        chessBoardView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        chessBoardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        chessBoardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        chessBoardView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.tableHeaderView = UIActivityIndicatorView(style: .large)
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: chessBoardView.bottomAnchor, constant: 8).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ViewController: ChessBoardViewDelegate {
    func didFind(paths: [Stack<ChessSquare>]) {
        self.paths = paths
        
        if paths.isEmpty {
            presentAlert(title: "No path found", message: "If you're lost, try increasing the cutoff for DFS", actions: [UIAlertAction(title: "OK", style: .cancel, handler: nil)])
        }
    }
    
    func clearPaths() {
        self.paths = []
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(indexPath.row).   " + paths[indexPath.row].description
        return cell
    }
}

extension ViewController {
    func presentAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alertController.addAction( $0 ) }
        present(alertController, animated: true, completion: nil)
    }
}
