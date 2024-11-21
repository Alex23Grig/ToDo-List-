//
//  ToDoListItemTests.swift
//  ToDo ListTests
//
//  Created by Alexander Grigoryev on 21.11.2024.
//

import XCTest
import CoreData
@testable import ToDo_List

class ToDoListItemTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    
    override func setUpWithError() throws {
        super.setUp()
        
        // Set up an in-memory persistent container
        persistentContainer = NSPersistentContainer(name: "ToDoListItem") // Replace with your model name
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        try persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                XCTFail("Failed to load in-memory store: \(error)")
            }
        })
    }
    
    override func tearDownWithError() throws {
        persistentContainer = nil
        super.tearDown()
    }
    
    func testToDoListItemCreation() throws {
        let context = persistentContainer.viewContext
        
        let newItem = ToDoListItem(context: context)
        newItem.title = "Test Title"
        newItem.completed = false
        newItem.toDoDescription = "Test Description"
        newItem.createdAt = Date()
        
        XCTAssertNoThrow(try context.save(), "Saving the context should not throw an error.")
    }
    
    func testFetchToDoListItems() throws {
        let context = persistentContainer.viewContext
        
        // Add a test item
        let newItem = ToDoListItem(context: context)
        newItem.title = "Test Title"
        newItem.completed = true
        newItem.toDoDescription = "Test Description"
        newItem.createdAt = Date()
        try context.save()
        
        // Fetch the item
        let fetchRequest: NSFetchRequest<ToDoListItem> = ToDoListItem.fetchRequest()
        let fetchedItems = try context.fetch(fetchRequest)
        
        XCTAssertEqual(fetchedItems.count, 1, "There should be exactly one ToDoListItem fetched.")
        XCTAssertEqual(fetchedItems.first?.title, "Test Title", "The fetched item's title should match the expected value.")
        XCTAssertTrue(fetchedItems.first?.completed == true, "The fetched item's completed status should be true.")
    }
    
    func testToDoListItemDefaults() throws {
        let context = persistentContainer.viewContext
        
        let newToDo = ToDoListItem(context: context)
        
        // Test the default values
        XCTAssertEqual(newToDo.title, "", "Default title should be an empty string.")
        XCTAssertFalse(newToDo.completed, "Default completed should be false.")
        XCTAssertEqual(newToDo.toDoDescription, "", "Default description should be an empty string.")
    }


    

}
