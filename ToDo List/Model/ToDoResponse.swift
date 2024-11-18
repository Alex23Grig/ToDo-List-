//
//  ToDoResponse.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 18.11.2024.
//

import Foundation

struct ToDoResponse: Codable {
    let todos: [ToDo]
    let total: Int
    let skip: Int
    let limit: Int
}
