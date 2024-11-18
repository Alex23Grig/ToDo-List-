//
//  ToDoListViewController.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 18.11.2024.
//

import Foundation
import UIKit

class ToDoListViewController: ViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK:  variables
    private let tableView = UITableView()
    private var todos: [ToDo] = []
    private var filteredTodos: [ToDo] = []
    private var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupSearchBar()
        setupTableView()
        
        loadData()
        
        fetchToDos { todos in
            guard let todos = todos else { return }
            DispatchQueue.main.async {
                print(todos)
            }
        }

    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .black
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .white
        
        
        let headerHeight: CGFloat = 80
        searchBar.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: headerHeight)
        
        tableView.tableHeaderView = searchBar
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "ToDoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadData() {
        // Загрузите данные из API и обновите таблицу
        fetchToDos { [weak self] todos in
            self?.todos = todos ?? []
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Amount of todos is \(todos.count)")
        return todos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        let todo = todos[indexPath.row]
        cell.configure(with: todo)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    

    //MARK:  api calls
  
    
    
    func fetchToDos(completion: @escaping ([ToDo]?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: "https://dummyjson.com/todos")!

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                do {
                    let toDoResponse = try JSONDecoder().decode(ToDoResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(toDoResponse.todos)
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            }.resume()
        }
    }

    
}


