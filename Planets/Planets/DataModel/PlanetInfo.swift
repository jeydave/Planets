//
//  PlanetInfo.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import Foundation

/// Data model for storing the Planet information
struct PlanetInfo: Equatable {
    var name: String?
    var rotationPeriod: String?
    var orbitalPeriod: String?
    var diameter: String?
    var climate: String?
    var gravity: String?
    var terrain: String?
    var surfaceWater: String?
    var population: String?
    var residents: [String]?
    var films: [String]?
    var created: String?
    var edited: String?
    var url: String
}

/// Data model for storing the Resident information
struct PeopleInfo: Equatable {
    var name: String?
    var height: String?
    var mass: String?
    var hairColor: String?
    var skinColor: String?
    var eyeColor: String?
    var birthYear: String?
    var gender: String?
    var homeworld: String?
    var films: [String]?
    var species: [String]?
    var vehicles: [String]?
    var starships: [String]?
    var created: String?
    var edited: String?
    var url: String
}

/// Data model for storing the Film information
struct FilmInfo: Equatable {
    var title: String?
    var episodeId: Int64?
    var openingCrawl: String?
    var director: String?
    var producer: String?
    var releaseDate: String?
    var characters: [String]?
    var planets: [String]?
    var starships: [String]?
    var vehicles: [String]?
    var species: [String]?
    var created: String?
    var edited: String?
    var url: String?
}
