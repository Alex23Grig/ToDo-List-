//
//  ToDoListItem+CoreDataProperties.swift
//  ToDo List
//
//  Created by Alexander Grigoryev on 18.11.2024.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var title: String
    @NSManaged public var completed: Bool
    @NSManaged public var toDoDescription: String
    @NSManaged public var createdAt: Date

}

extension ToDoListItem : Identifiable {

}
