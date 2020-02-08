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
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .lightGray
        spinner.hidesWhenStopped = true
        return spinner
    }()
    private var chessBoardWidth: NSLayoutConstraint?
    private var chessBoardHeight: NSLayoutConstraint?
    private var tableViewWidth: NSLayoutConstraint?
    private var tableViewHeight: NSLayoutConstraint?
    
    private var smallDimension: CGFloat {
        get {
            return view.bounds.width < view.bounds.height ?
                (view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right) :
                (view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        }
    }
    private var largeDimension: CGFloat {
        get {
            return view.bounds.width > view.bounds.height ?
                (view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right) :
                (view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        title = "Say Cheesse"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Resize", style: .plain, target: self, action: #selector(didPressResize(_:)))
        view.backgroundColor = UIColor.systemBackground
        setupBoardView()
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressResize(_ sender: UIBarButtonItem) {
        var actions: [UIAlertAction] = []
        for size in ChessBoard.validSizes {
            let action = UIAlertAction(title: "\(size) x \(size)", style: .default) { [weak self] (action) in
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
        
        let smallDimension = view.bounds.width < view.bounds.height ?
                (view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right) :
                (view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        
        chessBoardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        chessBoardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        chessBoardWidth = chessBoardView.widthAnchor.constraint(equalToConstant: smallDimension)
        chessBoardWidth?.isActive = true
        chessBoardHeight = chessBoardView.heightAnchor.constraint(equalToConstant: smallDimension)
        chessBoardHeight?.isActive = true
    }
    
    private func setupTableView() {
        tableView.tableHeaderView = spinner
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableViewWidth = tableView.widthAnchor.constraint(equalToConstant: smallDimension)
        tableViewWidth?.isActive = true
        tableViewHeight = tableView.heightAnchor.constraint(equalToConstant: largeDimension - smallDimension - chessBoardView.margin)
        tableViewHeight?.isActive = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        chessBoardWidth?.constant = smallDimension
        chessBoardHeight?.constant = smallDimension
        if view.bounds.height > view.bounds.width {
            tableViewWidth?.constant = smallDimension
            tableViewHeight?.constant = largeDimension - smallDimension - chessBoardView.margin
        } else {
            tableViewWidth?.constant = largeDimension - smallDimension - chessBoardView.margin
            tableViewHeight?.constant = smallDimension
        }
        
        super.updateViewConstraints()
    }
}

extension ViewController: ChessBoardViewDelegate {
    func didStartFindingPaths() {
        spinner.startAnimating()
    }
    
    func didFind(paths: [Stack<ChessSquare>]) {
        self.paths = paths
        spinner.stopAnimating()
        
        if paths.isEmpty {
            presentAlert(title: "No path found", message: "If you're lost, try increasing the cutoff for DFS", actions: [UIAlertAction(title: "OK", style: .cancel, handler: nil)])
        }
    }
    
    func clearPaths() {
        spinner.stopAnimating()
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
