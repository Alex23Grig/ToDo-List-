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
    var isKeyboardVisible: Bool = false
    
    let toDoManager = ToDoListManager()
    var toDoItems:[ToDoListItem] = []
    var filteredToDoItems: [ToDoListItem] = []
    var selectedToDo: ToDoListItem?
    private let toDoCountLabel = UILabel()
   
    //MARK:  viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        hideKeyboardWhenTappedAround()

  
        
        //nav panel buttons for testing
        // Set up the navigation bar button
        let rightButton = UIBarButtonItem(title: "Reset user defaults",
                                          style: .plain,
                                          target: self,
                                          action: #selector(rightButtonTapped))
        
        let leftButton = UIBarButtonItem(title: "Delete all",
                                          style: .plain,
                                          target: self,
                                          action: #selector(leftButtonTapped))
        
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem = leftButton

        //force dark mode so ui stays same
        overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.barStyle = .black
        
        setupSearchBar()
        setupTableView()
        setupBottomPanel()
        
        
    }
    
    @objc func rightButtonTapped() {
        print("Right button tapped")
        UserDefaults.standard.set(false, forKey: "isFirstLaunch")
        UserDefaults.standard.synchronize()
    }
    
    @objc func leftButtonTapped() {
        print("Left button tapped")
        deleteAllToDoItems()
        
    }
    
    func deleteAllToDoItems() {
        for item in toDoItems {
            toDoManager.deleteItem(item)
        }
        toDoItems.removeAll()
        filteredToDoItems.removeAll()
        updateToDoCountLabel()
        tableView.reloadData()
    }
    //MARK:  viewwillappear
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if isFirstLaunch() {
            print("First load")
            loadDataFromAPI()
        } else {
            //reset search bar text when come back from edit/create screens
            searchBar.text = ""
            updateToDoCountLabel()
            print("Not first load")
            DispatchQueue.global(qos: .background).async {
                let items = self.toDoManager.fetchAllItems()
                let sortedItems = items.sorted { $0.createdAt > $1.createdAt }
                
                DispatchQueue.main.async {
                    self.toDoItems = sortedItems
                    self.filteredToDoItems = sortedItems
                    self.updateToDoCountLabel()
                    self.tableView.reloadData()
                }
            }

        }
    }

    
    //MARK:   ui setup
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Поиск"
        searchBar.text = ""
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
        
        
        performSegue(withIdentifier: Constants.fromMainToCreateToDo, sender: self)
    }


    private func updateToDoCountLabel() {
        DispatchQueue.main.async {
            self.toDoCountLabel.text = String(self.searchBar.text?.isEmpty == false ? self.filteredToDoItems.count : self.toDoItems.count)
        }
    }

    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBar.text?.isEmpty == false ? filteredToDoItems.count : toDoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoTableViewCell
        let todo = searchBar.text?.isEmpty == false ? filteredToDoItems[indexPath.row] : toDoItems[indexPath.row]
        cell.configure(with: todo)
        return cell
    }

    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    //MARK:  UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        print("Tapped cell at \(indexPath.row)")
        guard let originalIndex = self.getOriginalIndex(for: indexPath.row) else { return }
        toDoItems[originalIndex].completed.toggle()
        
        toDoManager.updateItem(toDoItems[originalIndex], title: toDoItems[originalIndex].title, description: toDoItems[originalIndex].toDoDescription, completed: toDoItems[originalIndex].completed)
        
        DispatchQueue.main.async {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    //MARK:  swipe actions for table
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, completionHandler in
            guard let originalIndex = self.getOriginalIndex(for: indexPath.row) else {
                completionHandler(false)
                return
            }
            
            let itemToDelete = self.toDoItems[originalIndex]
            DispatchQueue.global(qos: .background).async {
                self.toDoManager.deleteItem(itemToDelete)
                
                DispatchQueue.main.async {
                    self.toDoItems.remove(at: originalIndex)
                    self.filteredToDoItems.remove(at: indexPath.row)
                    self.updateToDoCountLabel()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    completionHandler(true)
                }
            }
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Редактировать") { _, _, completionHandler in
            guard let originalIndex = self.getOriginalIndex(for: indexPath.row) else {
                completionHandler(false)
                return
            }
            
            DispatchQueue.main.async {
                self.selectedToDo = self.toDoItems[originalIndex]
                self.performSegue(withIdentifier: Constants.fromMainToEditToDo, sender: self)
                completionHandler(true)
            }
        }
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }


    
    //MARK:  Context Menu Setup
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { _ in
                guard let originalIndex = self.getOriginalIndex(for: indexPath.row) else { return }
                
                DispatchQueue.main.async {
                    self.selectedToDo = self.toDoItems[originalIndex]
                    self.performSegue(withIdentifier: Constants.fromMainToEditToDo, sender: self)
                }
            }

            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                guard let originalIndex = self.getOriginalIndex(for: indexPath.row) else { return }
                let itemToDelete = self.toDoItems[originalIndex]

                DispatchQueue.global(qos: .background).async {
                    self.toDoManager.deleteItem(itemToDelete)
                    
                    DispatchQueue.main.async {
                        self.toDoItems.remove(at: originalIndex)
                        self.filteredToDoItems.remove(at: indexPath.row)
                        self.updateToDoCountLabel()
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }

            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    //MARK: search bar functionality
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredToDoItems = toDoItems
        } else {
            filteredToDoItems = toDoItems.filter { item in
                item.title.lowercased().contains(searchText.lowercased()) ||
                item.toDoDescription.lowercased().contains(searchText.lowercased())
            }
        }
        updateToDoCountLabel()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


    //to properly delete/edit itmes when search is used
    func getOriginalIndex(for filteredIndex: Int) -> Int? {
        let filteredItem = filteredToDoItems[filteredIndex]
        return toDoItems.firstIndex { $0 === filteredItem }
    }


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        for todo in toDoResponse.todos {
                            self.toDoManager.createItem(
                                title: todo.todo,
                                description: todo.toDoDescription,
                                completed: todo.completed
                            )
                        }
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }

                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(error)
                }
            }.resume()
        }
    }
    
    private func loadDataFromAPI() {
        
        fetchToDosFromAPI { error in
            if let error = error {
                print("Failed to fetch or save todos: \(error.localizedDescription)")
            } else {
                print("Successfully fetched and saved todos!")
                DispatchQueue.global(qos: .background).async {
                    let items = self.toDoManager.fetchAllItems()
                    let sortedItems = items.sorted { $0.createdAt > $1.createdAt }
                    
                    DispatchQueue.main.async {
                        self.toDoItems = sortedItems
                        self.filteredToDoItems = sortedItems
                        self.updateToDoCountLabel()
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
        
    }

    //MARK:  segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.fromMainToEditToDo {
                if let destinationVC = segue.destination as? EditToDoViewController {
                    destinationVC.toDo = selectedToDo
                }
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


