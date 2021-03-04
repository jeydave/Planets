//
//  Planets+CoreDataProperties.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//
//

import Foundation
import CoreData


extension Planets {

    @nonobjc public class func planetsFetchRequest() -> NSFetchRequest<Planets> {
        return NSFetchRequest<Planets>(entityName: "Planets")
    }

    @NSManaged public var climate: String?
    @NSManaged public var created: String?
    @NSManaged public var diameter: String?
    @NSManaged public var edited: String?
    @NSManaged public var films: [String]?
    @NSManaged public var gravity: String?
    @NSManaged public var name: String?
    @NSManaged public var orbitalPeriod: String?
    @NSManaged public var population: String?
    @NSManaged public var residents: [String]?
    @NSManaged public var rotationPeriod: String?
    @NSManaged public var surfaceWater: String?
    @NSManaged public var terrain: String?
    @NSManaged public var url: String?

}
