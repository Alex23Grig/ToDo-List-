//
//  CoreDataManager.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 18.11.2024.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager() // Singleton instance

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListItem")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
