//
//  ToDoTableViewCellTests.swift
//  ToDo ListTests
//
//  Created by Alexander Grigoryev on 21.11.2024.
//

import XCTest
@testable import ToDo_List
import CoreData

final class ToDoTableViewCellTests: XCTestCase {
    
    var cell: ToDoTableViewCell!
    var context: NSManagedObjectContext!
    var mockToDoItem: ToDoListItem!
    
    override func setUp() {
        super.setUp()
        
        // Set up the in-memory managed object context for testing
        let persistentContainer = NSPersistentContainer(name: "ToDoListItem")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        context = persistentContainer.viewContext
        
        // Create a mock ToDoListItem entity
        mockToDoItem = ToDoListItem(context: context)
        mockToDoItem.title = "Test Task"
        mockToDoItem.toDoDescription = "Test Description"
        mockToDoItem.completed = false
        mockToDoItem.createdAt = Date()
        
        // Initialize the cell
        cell = ToDoTableViewCell(style: .default, reuseIdentifier: "ToDoCell")
    }
    
    override func tearDown() {
        // Clean up
        context = nil
        cell = nil
        mockToDoItem = nil
        super.tearDown()
    }
    
    func testConfigureCellWithIncompleteToDo() {
        // Given
        mockToDoItem.completed = false
        
        // When
        cell.configure(with: mockToDoItem)
        
        // Then
        XCTAssertEqual(cell.titleLabel.text, "Test Task")
        XCTAssertEqual(cell.descriptionLabel.text, "Test Description")
        XCTAssertEqual(cell.dateLabel.text, cell.formatDate(Date()))
        XCTAssertTrue(cell.checkmarkView.isHidden)
        XCTAssertEqual(cell.statusIndicator.layer.borderColor, UIColor.gray.cgColor)
        XCTAssertEqual(cell.titleLabel.textColor, UIColor.white)
    }
    
    func testConfigureCellWithCompletedToDo() {
        // Given
        mockToDoItem.completed = true
        
        // When
        cell.configure(with: mockToDoItem)
        
        // Then
        XCTAssertEqual(cell.titleLabel.text, "Test Task")
        XCTAssertEqual(cell.descriptionLabel.text, "Test Description")
        XCTAssertEqual(cell.dateLabel.text, cell.formatDate(Date()))
        XCTAssertFalse(cell.checkmarkView.isHidden)
        XCTAssertEqual(cell.statusIndicator.layer.borderColor, UIColor.systemYellow.cgColor)
        XCTAssertEqual(cell.titleLabel.textColor, UIColor(white: 0.8, alpha: 1))
        XCTAssertEqual(cell.titleLabel.attributedText?.string, "Test Task")
    }
    
    func testPrepareForReuse() {
        // Given
        mockToDoItem.completed = true
        cell.configure(with: mockToDoItem)
        
        // When
        cell.prepareForReuse()
        
        // Then
        XCTAssertNil(cell.titleLabel.attributedText)
        XCTAssertTrue(cell.checkmarkView.isHidden)
        XCTAssertEqual(cell.statusIndicator.layer.borderColor, UIColor.gray.cgColor)
        XCTAssertEqual(cell.titleLabel.textColor, UIColor.white)
    }
}

