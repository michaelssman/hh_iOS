//
//  Student+CoreDataProperties.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/20.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var age: Int64
    @NSManaged public var name: String?
    @NSManaged public var sex: String?
    @NSManaged public var relationship: Teacher?

}
