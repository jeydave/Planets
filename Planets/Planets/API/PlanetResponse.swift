//
//  PlanetResponse.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 26/02/21.
//

import Foundation

struct PlanetListResponse: Codable {
    var count: UInt
    var next: String?
    var previous: String?
    var results: [PlanetResponse]?
}

struct PlanetResponse: Codable {
    var name: String
    var rotationPeriod: String
    var orbitalPeriod: String
    var diameter: String
    var climate: String
    var gravity: String
    var terrain: String
    var surfaceWater: String
    var population: String
    var residents: [String]?
    var films: [String]?
    var created: String
    var edited: String
    var url: String
}

/*
 {
     "name": "Tatooine",
     "rotation_period": "23",
     "orbital_period": "304",
     "diameter": "10465",
     "climate": "arid",
     "gravity": "1 standard",
     "terrain": "desert",
     "surface_water": "1",
     "population": "200000",
     "residents": [
         "http://swapi.dev/api/people/1/",
         "http://swapi.dev/api/people/2/",
         "http://swapi.dev/api/people/4/",
         "http://swapi.dev/api/people/6/",
         "http://swapi.dev/api/people/7/",
         "http://swapi.dev/api/people/8/",
         "http://swapi.dev/api/people/9/",
         "http://swapi.dev/api/people/11/",
         "http://swapi.dev/api/people/43/",
         "http://swapi.dev/api/people/62/"
     ],
     "films": [
         "http://swapi.dev/api/films/1/",
         "http://swapi.dev/api/films/3/",
         "http://swapi.dev/api/films/4/",
         "http://swapi.dev/api/films/5/",
         "http://swapi.dev/api/films/6/"
     ],
     "created": "2014-12-09T13:50:49.641000Z",
     "edited": "2014-12-20T20:58:18.411000Z",
     "url": "http://swapi.dev/api/planets/1/"
 }
 */

/*
 Attributes:

 name string -- The name of this planet.
 diameter string -- The diameter of this planet in kilometers.
 rotation_period string -- The number of standard hours it takes for this planet to complete a single rotation on its axis.
 orbital_period string -- The number of standard days it takes for this planet to complete a single orbit of its local star.
 gravity string -- A number denoting the gravity of this planet, where "1" is normal or 1 standard G. "2" is twice or 2 standard Gs. "0.5" is half or 0.5 standard Gs.
 population string -- The average population of sentient beings inhabiting this planet.
 climate string -- The climate of this planet. Comma separated if diverse.
 terrain string -- The terrain of this planet. Comma separated if diverse.
 surface_water string -- The percentage of the planet surface that is naturally occurring water or bodies of water.
 residents array -- An array of People URL Resources that live on this planet.
 films array -- An array of Film URL Resources that this planet has appeared in.
 url string -- the hypermedia URL of this resource.
 created string -- the ISO 8601 date format of the time that this resource was created.
 edited string -- the ISO 8601 date format of the time that this resource was edited.
 */

struct PeopleResponse: Codable {
    var name: String
    var height: String
    var mass: String
    var hairColor: String
    var skinColor: String
    var eyeColor: String
    var birthYear: String
    var gender: String
    var homeworld: String
    var films: [String]?
    var species: [String]?
    var vehicles: [String]?
    var starships: [String]?
    var created: String
    var edited: String
    var url: String
}

/*
 {
     "name": "Luke Skywalker",
     "height": "172",
     "mass": "77",
     "hair_color": "blond",
     "skin_color": "fair",
     "eye_color": "blue",
     "birth_year": "19BBY",
     "gender": "male",
     "homeworld": "http://swapi.dev/api/planets/1/",
     "films": [
         "http://swapi.dev/api/films/1/",
         "http://swapi.dev/api/films/2/",
         "http://swapi.dev/api/films/3/",
         "http://swapi.dev/api/films/6/"
     ],
     "species": [],
     "vehicles": [
         "http://swapi.dev/api/vehicles/14/",
         "http://swapi.dev/api/vehicles/30/"
     ],
     "starships": [
         "http://swapi.dev/api/starships/12/",
         "http://swapi.dev/api/starships/22/"
     ],
     "created": "2014-12-09T13:50:51.644000Z",
     "edited": "2014-12-20T21:17:56.891000Z",
     "url": "http://swapi.dev/api/people/1/"
 }
 */

struct FilmResponse: Codable {
    var title: String
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
