//
//  StarWarsAPIParserTests.swift
//  PlanetsTests
//
//  Created by Andrew on 07/03/21.
//

import XCTest
@testable import Planets

class StarWarsAPIParserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

}

//MARK:- ParsePlanetListResponse func tests
extension StarWarsAPIParserTests {

    func testParsePlanetListResponseWithEmptyData() {
        let emptyPlanetData = "".data(using: .utf8)!
        let response = StarWarsAPIParser.parsePlanetListResponse(with: emptyPlanetData)
        XCTAssertNil(response, "Response should be nil")
    }

    func testParsePlanetListResponseWithEmptyResultsData() {
        let emptyPlanetResultData = """
        {
        "count": 60,
        "next": "http://swapi.dev/api/planets/?page=2",
        "previous": null,
        "results": []
        }
        """.data(using: .utf8)!
        let response = StarWarsAPIParser.parsePlanetListResponse(with: emptyPlanetResultData)
        XCTAssertNil(response, "Response should be nil")
    }
    
    func testParsePlanetListResponseWithWrongData() {
        let emptyPlanetResultData = """
        {
        "count": 0,
        "next": "null",
        "previous": null,
        "results1": []
        }
        """.data(using: .utf8)!
        let response = StarWarsAPIParser.parsePlanetListResponse(with: emptyPlanetResultData)
        XCTAssertNil(response, "Response should be nil")
    }
    
    func testParsePlanetListResponseWithValidSingleData() {
        let singlePlanetResultData = """
        {
            "count": 60,
            "next": "http://swapi.dev/api/planets/?page=2",
            "previous": null,
            "results": [
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
            ]
        }
        """.data(using: .utf8)!
        let response = StarWarsAPIParser.parsePlanetListResponse(with: singlePlanetResultData)
        XCTAssertNotNil(response, "Response should not be nil")
        XCTAssertTrue(response!.count == 1, "Response count should be 1")
        
        let expectedOutput = PlanetInfo(name: "Tatooine",
                                        rotationPeriod: "23",
                                        orbitalPeriod: "304",
                                        diameter: "10465",
                                        climate: "arid",
                                        gravity: "1 standard",
                                        terrain: "desert",
                                        surfaceWater: "1",
                                        population: "200000",
                                        residents: ["http://swapi.dev/api/people/1/",
                                                    "http://swapi.dev/api/people/2/",
                                                    "http://swapi.dev/api/people/4/",
                                                    "http://swapi.dev/api/people/6/",
                                                    "http://swapi.dev/api/people/7/",
                                                    "http://swapi.dev/api/people/8/",
                                                    "http://swapi.dev/api/people/9/",
                                                    "http://swapi.dev/api/people/11/",
                                                    "http://swapi.dev/api/people/43/",
                                                    "http://swapi.dev/api/people/62/"],
                                        films: ["http://swapi.dev/api/films/1/",
                                                "http://swapi.dev/api/films/3/",
                                                "http://swapi.dev/api/films/4/",
                                                "http://swapi.dev/api/films/5/",
                                                "http://swapi.dev/api/films/6/"],
                                        created: "2014-12-09T13:50:49.641000Z",
                                        edited: "2014-12-20T20:58:18.411000Z",
                                        url: "http://swapi.dev/api/planets/1/")
        XCTAssertTrue(response![0] == expectedOutput, "Expected output is wrong")
    }

    func testParsePlanetListResponseWithValidMultiData() {
        let singlePlanetResultData = """
        {
            "count": 60,
            "next": "http://swapi.dev/api/planets/?page=2",
            "previous": null,
            "results": [
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
                },
                {
                    "name": "Alderaan",
                    "rotation_period": "24",
                    "orbital_period": "364",
                    "diameter": "12500",
                    "climate": "temperate",
                    "gravity": "1 standard",
                    "terrain": "grasslands, mountains",
                    "surface_water": "40",
                    "population": "2000000000",
                    "residents": [
                        "http://swapi.dev/api/people/5/",
                        "http://swapi.dev/api/people/68/",
                        "http://swapi.dev/api/people/81/"
                    ],
                    "films": [
                        "http://swapi.dev/api/films/1/",
                        "http://swapi.dev/api/films/6/"
                    ],
                    "created": "2014-12-10T11:35:48.479000Z",
                    "edited": "2014-12-20T20:58:18.420000Z",
                    "url": "http://swapi.dev/api/planets/2/"
                }
            ]
        }
        """.data(using: .utf8)!

        let response = StarWarsAPIParser.parsePlanetListResponse(with: singlePlanetResultData)
        XCTAssertNotNil(response, "Response should not be nil")
        XCTAssertTrue(response!.count == 2, "Response count should be 2")
        
        let planet1Info = PlanetInfo(name: "Tatooine",
                                     rotationPeriod: "23",
                                     orbitalPeriod: "304",
                                     diameter: "10465",
                                     climate: "arid",
                                     gravity: "1 standard",
                                     terrain: "desert",
                                     surfaceWater: "1",
                                     population: "200000",
                                     residents: ["http://swapi.dev/api/people/1/",
                                                 "http://swapi.dev/api/people/2/",
                                                 "http://swapi.dev/api/people/4/",
                                                 "http://swapi.dev/api/people/6/",
                                                 "http://swapi.dev/api/people/7/",
                                                 "http://swapi.dev/api/people/8/",
                                                 "http://swapi.dev/api/people/9/",
                                                 "http://swapi.dev/api/people/11/",
                                                 "http://swapi.dev/api/people/43/",
                                                 "http://swapi.dev/api/people/62/"],
                                     films: ["http://swapi.dev/api/films/1/",
                                             "http://swapi.dev/api/films/3/",
                                             "http://swapi.dev/api/films/4/",
                                             "http://swapi.dev/api/films/5/",
                                             "http://swapi.dev/api/films/6/"],
                                     created: "2014-12-09T13:50:49.641000Z",
                                     edited: "2014-12-20T20:58:18.411000Z",
                                     url: "http://swapi.dev/api/planets/1/")
        let planet2Info = PlanetInfo(name: "Alderaan",
                                     rotationPeriod: "24",
                                     orbitalPeriod: "364",
                                     diameter: "12500",
                                     climate: "temperate",
                                     gravity: "1 standard",
                                     terrain: "grasslands, mountains",
                                     surfaceWater: "40",
                                     population: "2000000000",
                                     residents: [
                                      "http://swapi.dev/api/people/5/",
                                      "http://swapi.dev/api/people/68/",
                                      "http://swapi.dev/api/people/81/"
                                     ],
                                     films: ["http://swapi.dev/api/films/1/",
                                             "http://swapi.dev/api/films/6/"],
                                     created: "2014-12-10T11:35:48.479000Z",
                                     edited: "2014-12-20T20:58:18.420000Z",
                                     url: "http://swapi.dev/api/planets/2/")
        let expectedOutput = [planet1Info, planet2Info]
        
        XCTAssertTrue(response! == expectedOutput, "Expected output is wrong")
    }
}

//MARK:- ParsePersonListResponse func tests
extension StarWarsAPIParserTests {
    
    func testParsePersonListResponseWithEmptyData() {
        let data = "".data(using: .utf8)!
        let response = StarWarsAPIParser.parsePersonResponse(with: data)
        XCTAssertNil(response, "Response should be nil for invalid data")
    }
    
    func testParsePersonListResponseWithValidData() {
        let data = """
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
        """.data(using: .utf8)!
        let response = StarWarsAPIParser.parsePersonResponse(with: data)
        XCTAssertNotNil(response, "Response shouldnt be nil for valid data")
        let expectedOutput = PeopleInfo(name: "Luke Skywalker",
                                        height: "172",
                                        mass: "77",
                                        hairColor: "blond",
                                        skinColor: "fair",
                                        eyeColor: "blue",
                                        birthYear: "19BBY",
                                        gender: "male",
                                        homeworld: "http://swapi.dev/api/planets/1/",
                                        films: ["http://swapi.dev/api/films/1/",
                                                "http://swapi.dev/api/films/2/",
                                                "http://swapi.dev/api/films/3/",
                                                "http://swapi.dev/api/films/6/"],
                                        species: [],
                                        vehicles: ["http://swapi.dev/api/vehicles/14/",
                                                   "http://swapi.dev/api/vehicles/30/"],
                                        starships: ["http://swapi.dev/api/starships/12/",
                                                    "http://swapi.dev/api/starships/22/"],
                                        created: "2014-12-09T13:50:51.644000Z",
                                        edited: "2014-12-20T21:17:56.891000Z",
                                        url: "http://swapi.dev/api/people/1/")
        XCTAssertTrue(response == expectedOutput, "Didnt receive the expected output")
    }
    
    func testParsePersonListResponseWithInvalidData() {
        let data = """
        {
            "name1": "Luke Skywalker",
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
        """.data(using: .utf8)!
        let response = StarWarsAPIParser.parsePersonResponse(with: data)
        XCTAssertNil(response, "Response shouldnt be nil for valid data")
    }
}

//MARK:- ParseFilmListResponse func tests
extension StarWarsAPIParserTests {
    
    func testParseFilmListResponseWithEmptyData() {
        let data = "".data(using: .utf8)!
        let response = StarWarsAPIParser.parseFilmResponse(with: data)
        XCTAssertNil(response, "Response should be nil for invalid data")
    }
    
    func testParseFilmListResponseForValidData() {
        let data = """
            {
                "title": "A New Hope",
                "episode_id": 4,
                "opening_crawl": "It is a period of civil war.",
                "director": "George Lucas",
                "producer": "Gary Kurtz, Rick McCallum",
                "release_date": "1977-05-25",
                "characters": [
                    "http://swapi.dev/api/people/1/",
                    "http://swapi.dev/api/people/2/",
                    "http://swapi.dev/api/people/3/",
                    "http://swapi.dev/api/people/4/",
                    "http://swapi.dev/api/people/5/",
                    "http://swapi.dev/api/people/6/",
                    "http://swapi.dev/api/people/7/",
                    "http://swapi.dev/api/people/8/",
                    "http://swapi.dev/api/people/9/",
                    "http://swapi.dev/api/people/10/",
                    "http://swapi.dev/api/people/12/",
                    "http://swapi.dev/api/people/13/",
                    "http://swapi.dev/api/people/14/",
                    "http://swapi.dev/api/people/15/",
                    "http://swapi.dev/api/people/16/",
                    "http://swapi.dev/api/people/18/",
                    "http://swapi.dev/api/people/19/",
                    "http://swapi.dev/api/people/81/"
                ],
                "planets": [
                    "http://swapi.dev/api/planets/1/",
                    "http://swapi.dev/api/planets/2/",
                    "http://swapi.dev/api/planets/3/"
                ],
                "starships": [
                    "http://swapi.dev/api/starships/2/",
                    "http://swapi.dev/api/starships/3/",
                    "http://swapi.dev/api/starships/5/",
                    "http://swapi.dev/api/starships/9/",
                    "http://swapi.dev/api/starships/10/",
                    "http://swapi.dev/api/starships/11/",
                    "http://swapi.dev/api/starships/12/",
                    "http://swapi.dev/api/starships/13/"
                ],
                "vehicles": [
                    "http://swapi.dev/api/vehicles/4/",
                    "http://swapi.dev/api/vehicles/6/",
                    "http://swapi.dev/api/vehicles/7/",
                    "http://swapi.dev/api/vehicles/8/"
                ],
                "species": [
                    "http://swapi.dev/api/species/1/",
                    "http://swapi.dev/api/species/2/",
                    "http://swapi.dev/api/species/3/",
                    "http://swapi.dev/api/species/4/",
                    "http://swapi.dev/api/species/5/"
                ],
                "created": "2014-12-10T14:23:31.880000Z",
                "edited": "2014-12-20T19:49:45.256000Z",
                "url": "http://swapi.dev/api/films/1/"
            }
        """.data(using: .utf8)!
        let response = StarWarsAPIParser.parseFilmResponse(with: data)
        let expectedOutput = FilmInfo(title: "A New Hope",
                                      episodeId: 4,
                                      openingCrawl: "It is a period of civil war.",
                                      director: "George Lucas",
                                      producer: "Gary Kurtz, Rick McCallum",
                                      releaseDate: "1977-05-25",
                                      characters: [
                                        "http://swapi.dev/api/people/1/",
                                        "http://swapi.dev/api/people/2/",
                                        "http://swapi.dev/api/people/3/",
                                        "http://swapi.dev/api/people/4/",
                                        "http://swapi.dev/api/people/5/",
                                        "http://swapi.dev/api/people/6/",
                                        "http://swapi.dev/api/people/7/",
                                        "http://swapi.dev/api/people/8/",
                                        "http://swapi.dev/api/people/9/",
                                        "http://swapi.dev/api/people/10/",
                                        "http://swapi.dev/api/people/12/",
                                        "http://swapi.dev/api/people/13/",
                                        "http://swapi.dev/api/people/14/",
                                        "http://swapi.dev/api/people/15/",
                                        "http://swapi.dev/api/people/16/",
                                        "http://swapi.dev/api/people/18/",
                                        "http://swapi.dev/api/people/19/",
                                        "http://swapi.dev/api/people/81/"
                                    ],
                                      planets: [
                                        "http://swapi.dev/api/planets/1/",
                                        "http://swapi.dev/api/planets/2/",
                                        "http://swapi.dev/api/planets/3/"
                                    ],
                                      starships: [
                                        "http://swapi.dev/api/starships/2/",
                                        "http://swapi.dev/api/starships/3/",
                                        "http://swapi.dev/api/starships/5/",
                                        "http://swapi.dev/api/starships/9/",
                                        "http://swapi.dev/api/starships/10/",
                                        "http://swapi.dev/api/starships/11/",
                                        "http://swapi.dev/api/starships/12/",
                                        "http://swapi.dev/api/starships/13/"
                                    ],
                                      vehicles: [
                                        "http://swapi.dev/api/vehicles/4/",
                                        "http://swapi.dev/api/vehicles/6/",
                                        "http://swapi.dev/api/vehicles/7/",
                                        "http://swapi.dev/api/vehicles/8/"
                                    ],
                                      species: [
                                        "http://swapi.dev/api/species/1/",
                                        "http://swapi.dev/api/species/2/",
                                        "http://swapi.dev/api/species/3/",
                                        "http://swapi.dev/api/species/4/",
                                        "http://swapi.dev/api/species/5/"
                                    ],
                                      created: "2014-12-10T14:23:31.880000Z",
                                      edited: "2014-12-20T19:49:45.256000Z",
                                      url: "http://swapi.dev/api/films/1/")
        XCTAssertNotNil(response, "Response should not be nil for valid data")
        XCTAssertTrue(response == expectedOutput, "Didnt get the expected output")
    }
    
    func testParseFilmListResponseForInvalidData() {
        let data = """
            {
                "titleee": "A New Hope",
                "episode_id": 4,
                "opening_crawl": "It is a period of civil war.",
                "director": "George Lucas",
                "producer": "Gary Kurtz, Rick McCallum",
                "release_date": "1977-05-25",
                "characters": [
                    "http://swapi.dev/api/people/1/",
                    "http://swapi.dev/api/people/2/",
                    "http://swapi.dev/api/people/3/",
                    "http://swapi.dev/api/people/4/",
                    "http://swapi.dev/api/people/5/",
                    "http://swapi.dev/api/people/6/",
                    "http://swapi.dev/api/people/7/",
                    "http://swapi.dev/api/people/8/",
                    "http://swapi.dev/api/people/9/",
                    "http://swapi.dev/api/people/10/",
                    "http://swapi.dev/api/people/12/",
                    "http://swapi.dev/api/people/13/",
                    "http://swapi.dev/api/people/14/",
                    "http://swapi.dev/api/people/15/",
                    "http://swapi.dev/api/people/16/",
                    "http://swapi.dev/api/people/18/",
                    "http://swapi.dev/api/people/19/",
                    "http://swapi.dev/api/people/81/"
                ],
                "planets": [
                    "http://swapi.dev/api/planets/1/",
                    "http://swapi.dev/api/planets/2/",
                    "http://swapi.dev/api/planets/3/"
                ],
                "starships": [
                    "http://swapi.dev/api/starships/2/",
                    "http://swapi.dev/api/starships/3/",
                    "http://swapi.dev/api/starships/5/",
                    "http://swapi.dev/api/starships/9/",
                    "http://swapi.dev/api/starships/10/",
                    "http://swapi.dev/api/starships/11/",
                    "http://swapi.dev/api/starships/12/",
                    "http://swapi.dev/api/starships/13/"
                ],
                "vehicles": [
                    "http://swapi.dev/api/vehicles/4/",
                    "http://swapi.dev/api/vehicles/6/",
                    "http://swapi.dev/api/vehicles/7/",
                    "http://swapi.dev/api/vehicles/8/"
                ],
                "species": [
                    "http://swapi.dev/api/species/1/",
                    "http://swapi.dev/api/species/2/",
                    "http://swapi.dev/api/species/3/",
                    "http://swapi.dev/api/species/4/",
                    "http://swapi.dev/api/species/5/"
                ],
                "created": "2014-12-10T14:23:31.880000Z",
                "edited": "2014-12-20T19:49:45.256000Z",
                "url": "http://swapi.dev/api/films/1/"
            }
        """.data(using: .utf8)!
        let response = StarWarsAPIParser.parseFilmResponse(with: data)
        XCTAssertNil(response, "Response should be nil for invalid parsing")
    }
}
