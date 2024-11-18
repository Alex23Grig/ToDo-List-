//
//  ToDoListViewController.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 18.11.2024.
//

import Foundation
import UIKit

class ToDoListViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchToDos { todos in
            guard let todos = todos else { return }
            DispatchQueue.main.async {
                print(todos)
            }
        }

    }
    
    
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
