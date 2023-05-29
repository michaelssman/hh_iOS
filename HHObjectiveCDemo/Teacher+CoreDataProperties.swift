//
//  Teacher+CoreDataProperties.swift
//  HHObjectiveCDemo
//
//  Created by Michael on 2023/4/20.
//
//

import Foundation
import CoreData


extension Teacher {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teacher> {
        return NSFetchRequest<Teacher>(entityName: "Teacher")
    }

    @NSManaged public var address: String?
    @NSManaged public var name: String?
    @NSManaged public var relationship: NSSet?

}

// MARK: Generated accessors for relationship
extension Teacher {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Student)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Student)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)

}
