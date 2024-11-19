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
    
    private let toDoCountLabel = UILabel()
   
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
        setupBottomPanel()
        
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70)
        ])
        
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }

    private func setupBottomPanel() {
        
        let unsafeAreaView = UIView()
        unsafeAreaView.translatesAutoresizingMaskIntoConstraints = false
        unsafeAreaView.backgroundColor = .systemGray6
        view.addSubview(unsafeAreaView)
        
        
        let bottomPanel = UIView()
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false
        bottomPanel.backgroundColor = .systemGray6
        view.addSubview(bottomPanel)

        toDoCountLabel.translatesAutoresizingMaskIntoConstraints = false
        toDoCountLabel.text = ""
        toDoCountLabel.font = .boldSystemFont(ofSize: 16)
        toDoCountLabel.textColor = .lightGray
        bottomPanel.addSubview(toDoCountLabel)

        let createNewToDoButton = UIButton()
        createNewToDoButton.translatesAutoresizingMaskIntoConstraints = false
        createNewToDoButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        createNewToDoButton.tintColor = .systemYellow
        createNewToDoButton.addTarget(self, action: #selector(createNewToDoButtonTapped), for: .touchUpInside)
        bottomPanel.addSubview(createNewToDoButton)
        
        
        NSLayoutConstraint.activate([
            unsafeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            unsafeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            unsafeAreaView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            unsafeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomPanel.heightAnchor.constraint(equalToConstant: 40),

            toDoCountLabel.centerXAnchor.constraint(equalTo: bottomPanel.centerXAnchor),
            toDoCountLabel.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),

            createNewToDoButton.trailingAnchor.constraint(equalTo: bottomPanel.trailingAnchor, constant: -16),
            createNewToDoButton.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),
            createNewToDoButton.widthAnchor.constraint(equalToConstant: 50),
            createNewToDoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func createNewToDoButtonTapped() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        
        performSegue(withIdentifier: Constants.fromMainToSpecificToDo, sender: self)
    }


    //MARK:  api calls
    
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
                    self.toDoCountLabel.text = String(self.toDoItems.count)
                }
            }
        }

    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.async {
            self.toDoCountLabel.text = String(self.toDoItems.count)
        }
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
        toDoManager.updateItem(toDoItems[indexPath.row], title: toDoItems[indexPath.row].title, description: toDoItems[indexPath.row].toDoDescription, completed: toDoItems[indexPath.row].completed)
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


