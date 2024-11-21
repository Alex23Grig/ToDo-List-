//
//  ToDoListManagerTests.swift
//  ToDo ListTests
//
//  Created by Alexander Grigoryev on 20.11.2024.
//
//

//import XCTest
//import CoreData
//@testable import ToDo_List
//
//final class ToDoListManagerTests: XCTestCase {
//    
//    var toDoListManager: ToDoListManager!
//    var persistentContainer: NSPersistentContainer!
//    var coreDataManager: CoreDataManager!
//    
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        
//        // Create an in-memory NSPersistentContainer
//        persistentContainer = NSPersistentContainer(name: "ToDoListItem")
//        let description = NSPersistentStoreDescription()
//        description.type = NSInMemoryStoreType
//        persistentContainer.persistentStoreDescriptions = [description]
//        
//        persistentContainer.loadPersistentStores { _, error in
//            if let error = error {
//                fatalError("Failed to load in-memory Core Data stack: \(error)")
//            }
//        }
//        
//        // Inject in-memory Core Data stack into CoreDataManager
//        coreDataManager = CoreDataManager(container: persistentContainer)
//        toDoListManager = ToDoListManager(coreDataManager: coreDataManager)
//    }
//    
//    override func tearDownWithError() throws {
//        toDoListManager = nil
//        persistentContainer = nil
//        coreDataManager = nil
//        try super.tearDownWithError()
//    }
//}
