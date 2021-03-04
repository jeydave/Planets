//
//  Person+CoreDataProperties.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 28/02/21.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func personfetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var height: String?
    @NSManaged public var mass: String?
    @NSManaged public var hairColor: String?
    @NSManaged public var skinColor: String?
    @NSManaged public var eyeColor: String?
    @NSManaged public var birthYear: String?
    @NSManaged public var gender: String?
    @NSManaged public var homeworld: String?
    @NSManaged public var films: [String]?
    @NSManaged public var species: [String]?
    @NSManaged public var vehicles: [String]?
    @NSManaged public var starships: [String]?
    @NSManaged public var created: String?
    @NSManaged public var edited: String?
    @NSManaged public var url: String?

}
