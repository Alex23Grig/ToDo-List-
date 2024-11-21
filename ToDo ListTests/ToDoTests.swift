//
//  ToDoTests.swift
//  ToDo ListTests
//
//  Created by Alexander Grigoryev on 21.11.2024.
//

import XCTest
@testable import ToDo_List


final class ToDoTests: XCTestCase {
    func testInitializationWithDefaultValues() {
        // Arrange
        let id = 1
        let todo = "Test Task"
        let completed = false
        let userId = 123
        
        // Act
        let toDo = ToDo(id: id, todo: todo, completed: completed, userId: userId)
        
        // Assert
        XCTAssertEqual(toDo.id, id)
        XCTAssertEqual(toDo.todo, todo)
        XCTAssertEqual(toDo.completed, completed)
        XCTAssertEqual(toDo.userId, userId)
        XCTAssertEqual(toDo.toDoDescription, "")
        XCTAssertNotNil(toDo.createdAt)
    }
    
    func testInitializationWithCustomValues() {
        // Arrange
        let id = 1
        let todo = "Test Task"
        let completed = true
        let userId = 456
        let description = "This is a test task"
        let customDate = Date(timeIntervalSince1970: 0) // Jan 1, 1970
        
        // Act
        let toDo = ToDo(id: id, todo: todo, completed: completed, userId: userId, toDoDescription: description, createdAt: customDate)
        
        // Assert
        XCTAssertEqual(toDo.id, id)
        XCTAssertEqual(toDo.todo, todo)
        XCTAssertEqual(toDo.completed, completed)
        XCTAssertEqual(toDo.userId, userId)
        XCTAssertEqual(toDo.toDoDescription, description)
        XCTAssertEqual(toDo.createdAt, customDate)
    }
    
    func testDecodingFromJSON() throws {
        // Arrange
        let json = """
        {
            "id": 1,
            "todo": "Test Task",
            "completed": true,
            "userId": 123
        }
        """.data(using: .utf8)!
        
        // Act
        let decodedToDo = try JSONDecoder().decode(ToDo.self, from: json)
        
        // Assert
        XCTAssertEqual(decodedToDo.id, 1)
        XCTAssertEqual(decodedToDo.todo, "Test Task")
        XCTAssertEqual(decodedToDo.completed, true)
        XCTAssertEqual(decodedToDo.userId, 123)
        XCTAssertEqual(decodedToDo.toDoDescription, "")
        XCTAssertNotNil(decodedToDo.createdAt) // Should default to the current date
    }
    
    func testEncodingToJSON() throws {
        // Arrange
        let toDo = ToDo(id: 2, todo: "Another Task", completed: false, userId: 456, toDoDescription: "Description")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // Act
        let jsonData = try encoder.encode(toDo)
        let jsonString = String(data: jsonData, encoding: .utf8)
        
        // Assert
        XCTAssertNotNil(jsonString)
        XCTAssertTrue(jsonString!.contains("\"id\" : 2"))
        XCTAssertTrue(jsonString!.contains("\"todo\" : \"Another Task\""))
        XCTAssertTrue(jsonString!.contains("\"completed\" : false"))
        XCTAssertTrue(jsonString!.contains("\"userId\" : 456"))
    }
    
    func testDescriptionFieldDefaultsToEmpty() throws {
        // Arrange
        let json = """
        {
            "id": 1,
            "todo": "Task without description",
            "completed": false,
            "userId": 789
        }
        """.data(using: .utf8)!
        
        // Act
        let decodedToDo = try JSONDecoder().decode(ToDo.self, from: json)
        
        // Assert
        XCTAssertEqual(decodedToDo.toDoDescription, "") // Defaults to empty string if not present in JSON
    }
}

