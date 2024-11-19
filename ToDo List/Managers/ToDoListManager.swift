//
//  ToDoListManager.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 19.11.2024.
//


import CoreData

class ToDoListManager {
    private let context = CoreDataManager.shared.context

    
    
    func saveStructArray(_ items: [ToDo]) {
           for item in items {
               let newItem = ToDoListItem(context: context)
               newItem.title = item.todo
               newItem.completed = item.completed
               newItem.toDoDescription = item.toDoDescription
               newItem.createdAt = item.createdAt
           }
           saveChanges()
       }
    
    
    // MARK: CRUD
    func createItem(title: String, description: String?, completed: Bool = false) {
        let newItem = ToDoListItem(context: context)
        newItem.title = title
        newItem.toDoDescription = description
        newItem.completed = completed
        newItem.createdAt = Date()
        saveChanges()
    }

    
    func fetchAllItems() -> [ToDoListItem] {
        let fetchRequest: NSFetchRequest<ToDoListItem> = ToDoListItem.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch items: \(error)")
            return []
        }
    }

    func updateItem(_ item: ToDoListItem, title: String?, description: String?, completed: Bool?) {
        if let title = title {
            item.title = title
        }
        if let description = description {
            item.toDoDescription = description
        }
        if let completed = completed {
            item.completed = completed
        }
        saveChanges()
    }

    func deleteItem(_ item: ToDoListItem) {
        context.delete(item)
        saveChanges()
    }

    private func saveChanges() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
