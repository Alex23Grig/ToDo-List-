//
//  ToDo.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 18.11.2024.
//

import Foundation

struct ToDo: Codable {
    let id: Int
    var todo: String
    var completed: Bool
    let userId: Int
    var toDoDescription: String = ""
    var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, todo, completed, userId, toDoDescription, createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        todo = try container.decode(String.self, forKey: .todo)
        completed = try container.decode(Bool.self, forKey: .completed)
        userId = try container.decode(Int.self, forKey: .userId)
        toDoDescription = try container.decodeIfPresent(String.self, forKey: .toDoDescription) ?? ""
        createdAt = Date()
    }
    
    
    init(id: Int, todo: String, completed: Bool, userId: Int, toDoDescription: String = "", createdAt: Date = Date()) {
        self.id = id
        self.todo = todo
        self.completed = completed
        self.userId = userId
        self.toDoDescription = toDoDescription
        self.createdAt = createdAt
    }
}


