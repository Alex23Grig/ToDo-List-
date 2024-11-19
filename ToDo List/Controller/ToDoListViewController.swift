//
//  ToDoListViewController.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 18.11.2024.
//

import Foundation
import UIKit
import CoreData

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //MARK:  variables
    private let tableView = UITableView()
    private var searchBar: UISearchBar!
    
    let toDoManager = ToDoListManager()
    var toDoItems:[ToDoListItem] = []
    
   
    //MARK:  viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        
//        
//        for item in toDoItems {
//            toDoManager.deleteItem(item)
//        }
        
//        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
//        UserDefaults.standard.synchronize()
        
        setupSearchBar()
        setupTableView()
        
        if isFirstLaunch() {
            print("This is the first launch of the app!")
            loadDataFromAPI()
        } else {
            print("Welcome back!")
            toDoItems = toDoManager.fetchAllItems().sorted { $0.createdAt > $1.createdAt }
        }
    }
    
    //MARK:   ui setup
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
    
    private func loadDataFromAPI() {
        
        fetchToDosFromAPI { error in
            if let error = error {
                print("Failed to fetch or save todos: \(error.localizedDescription)")
            } else {
                print("Successfully fetched and saved todos!")
                
                // Fetch and print all items for confirmation
                
                let items = self.toDoManager.fetchAllItems()
                self.toDoItems = items.sorted { $0.createdAt > $1.createdAt }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }

    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        let todo = toDoItems[indexPath.row]
        cell.configure(with: todo)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    //MARK:  UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoItems[indexPath.row].completed.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    

    //MARK:  api calls
  


    
    func fetchToDosFromAPI(completion: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let url = URL(string: Constants.apiURL)!

            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                    completion(error)
                    return
                }

                do {
                    // Decode the JSON response
                    let toDoResponse = try JSONDecoder().decode(ToDoResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        for todo in toDoResponse.todos {
                            self.toDoManager.createItem(
                                title: todo.todo,
                                description: todo.toDoDescription,
                                completed: todo.completed
                            )
                        }
                        
                        completion(nil)
                    }
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(error)
                }
            }.resume()
        }
    }

    
    //MARK:  user defaults check
    
    func isFirstLaunch() -> Bool {
        let userDefaults = UserDefaults.standard
        let firstLaunchKey = "isFirstLaunch"
        
        if userDefaults.bool(forKey: firstLaunchKey) {
            return false
        } else {
            
            userDefaults.set(true, forKey: firstLaunchKey)
            userDefaults.synchronize()
            return true
        }
    }
}


