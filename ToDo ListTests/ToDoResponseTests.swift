//
//  ToDoResponseTests.swift
//  ToDo ListTests
//
//  Created by Alexander Grigoryev on 21.11.2024.
//

import XCTest
@testable import ToDo_List

final class ToDoResponseTests: XCTestCase {
    func testDecodingToDoResponseFromValidJSON() throws {
        // mock valid JSON
        let json = """
        {
            "todos": [
                {
                    "id": 1,
                    "todo": "Test Task 1",
                    "completed": false,
                    "userId": 123
                },
                {
                    "id": 2,
                    "todo": "Test Task 2",
                    "completed": true,
                    "userId": 456
                }
            ],
            "total": 2,
            "skip": 0,
            "limit": 10
        }
        """.data(using: .utf8)!
        
        // decode JSON
        let response = try JSONDecoder().decode(ToDoResponse.self, from: json)
        
        // validate decoded data
        XCTAssertEqual(response.todos.count, 2)
        XCTAssertEqual(response.todos[0].todo, "Test Task 1")
        XCTAssertEqual(response.todos[1].completed, true)
        XCTAssertEqual(response.total, 2)
        XCTAssertEqual(response.skip, 0)
        XCTAssertEqual(response.limit, 10)
    }
    
    func testDecodingToDoResponseWithEmptyTodos() throws {
        // mock JSON with no todos
        let json = """
        {
            "todos": [],
            "total": 0,
            "skip": 0,
            "limit": 10
        }
        """.data(using: .utf8)!
        
        // decode JSON
        let response = try JSONDecoder().decode(ToDoResponse.self, from: json)
        
        // validate decoded data
        XCTAssertEqual(response.todos.count, 0)
        XCTAssertEqual(response.total, 0)
        XCTAssertEqual(response.skip, 0)
        XCTAssertEqual(response.limit, 10)
    }
    
    func testDecodingFailsForInvalidJSON() {
        // mock invalid JSON
        let json = """
        {
            "todos": [
                {
                    "id": "one",
                    "todo": "Invalid Task",
                    "completed": "no",
                    "userId": "unknown"
                }
            ],
            "total": "many",
            "skip": 0,
            "limit": "lots"
        }
        """.data(using: .utf8)!
        
        // decode and validate error is thrown
        XCTAssertThrowsError(try JSONDecoder().decode(ToDoResponse.self, from: json))
    }
    
    func testDecodingPartialData() throws {
        // mock JSON missing optional data
        let json = """
        {
            "todos": [
                {
                    "id": 1,
                    "todo": "Partial Task",
                    "completed": false,
                    "userId": 123
                }
            ],
            "total": 1,
            "skip": 0,
            "limit": 10
        }
        """.data(using: .utf8)!
        
        // decode JSON
        let response = try JSONDecoder().decode(ToDoResponse.self, from: json)
        
        // validate decoded data
        XCTAssertEqual(response.todos.count, 1)
        XCTAssertEqual(response.todos[0].todo, "Partial Task")
        XCTAssertEqual(response.total, 1)
        XCTAssertEqual(response.skip, 0)
        XCTAssertEqual(response.limit, 10)
    }
}
