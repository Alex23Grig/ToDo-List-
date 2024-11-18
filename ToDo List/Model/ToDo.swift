//
//  ToDo.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 18.11.2024.
//


struct ToDo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    var description: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, todo, completed, userId, description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        todo = try container.decode(String.self, forKey: .todo)
        completed = try container.decode(Bool.self, forKey: .completed)
        userId = try container.decode(Int.self, forKey: .userId)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
    }
}
