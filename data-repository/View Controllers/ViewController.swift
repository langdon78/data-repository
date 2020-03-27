//
//  ViewController.swift
//  data-repository
//
//  Created by James Langdon on 3/20/20.
//  Copyright © 2020 corporatelangdon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    let repository = Repository()
    
    var todos: [Todo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHeader()
        refreshData()
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData() {
        repository.placeholder().todos { (response: Result<[Todo], ResponseError>) in
            switch response {
            case .success(let todos):
                self.todos = todos
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    func configureHeader() {
        let label = UILabel()
        label.text = "Todo List"
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.textColor = .black
        label.sizeToFit()
        tableView.tableHeaderView = label
        tableView.tableHeaderView?.backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0),
            label.topAnchor.constraint(equalTo: tableView.tableHeaderView!.topAnchor),
            label.bottomAnchor.constraint(equalTo: tableView.tableHeaderView!.bottomAnchor)
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = sender as? IndexPath,
            let detailViewController = segue.destination as? TodoDetailViewController
        else { return }
        
        detailViewController.todo = todos[indexPath.row]
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todos[indexPath.row].title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueTodoDetail", sender: indexPath)
    }
}
