//
//  Films+CoreDataProperties.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 28/02/21.
//
//

import Foundation
import CoreData


extension Films {

    @nonobjc public class func filmFetchRequest() -> NSFetchRequest<Films> {
        return NSFetchRequest<Films>(entityName: "Films")
    }

    @NSManaged public var characters: [String]?
    @NSManaged public var created: String?
    @NSManaged public var director: String?
    @NSManaged public var episodeId: Int64
    @NSManaged public var openingCrawl: String?
    @NSManaged public var planets: [String]?
    @NSManaged public var producer: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var species: [String]?
    @NSManaged public var starships: [String]?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var vehicles: [String]?
    @NSManaged public var edited: String?

}
