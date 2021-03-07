//
//  PlanetsHelperTests.swift
//  PlanetsTests
//
//  Created by Andrew on 07/03/21.
//

import XCTest
@testable import Planets

class PlanetsHelperTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPeopleUrlsWithEmptyPlanetInfo() {
        let peopleUrls = PlanetsHelper.peopleUrls(from: [])
        XCTAssertNotNil(peopleUrls, "People Urls shouldnt be nil")
        XCTAssertTrue(peopleUrls.isEmpty, "People urls' count should be 0")
    }
    
    func testPeopleUrlsWithSinglePlanetInfoAndValidResidentUrl() {
        let peopleUrls = PlanetsHelper.peopleUrls(from: [PlanetInfo(name:"Planet1", residents: ["personUrl1"], url: "url1")])
        XCTAssertNotNil(peopleUrls, "People Urls shouldnt be nil")
        XCTAssertTrue(peopleUrls.count == 1, "People urls' count should be 1")
        XCTAssertTrue(peopleUrls == ["personUrl1"], "Expected person urls is wrong")
    }
    
    func testPeopleUrlsWithSinglePlanetInfoAndNilResidentUrl() {
        let peopleUrls = PlanetsHelper.peopleUrls(from: [PlanetInfo(name:"Planet1", url: "url1")])
        XCTAssertNotNil(peopleUrls, "People Urls shouldnt be nil")
        XCTAssertTrue(peopleUrls.isEmpty, "People urls' count should be 0")
    }
    
    func testPeopleUrlsWithSinglePlanetInfoAndTwoResidentUrl() {
        let peopleUrls = PlanetsHelper.peopleUrls(from: [PlanetInfo(name:"Planet1", residents: ["personUrl1", "personUrl2"], url: "url1")])
        XCTAssertNotNil(peopleUrls, "People Urls shouldnt be nil")
        XCTAssertTrue(peopleUrls.count == 2, "People urls' count should be 2")
        XCTAssertTrue(peopleUrls == ["personUrl1", "personUrl2"], "Expected person urls is wrong")
    }

    func testPeopleUrlsWithTwoPlanetInfoAndNoResidentUrl() {
        let peopleUrls = PlanetsHelper.peopleUrls(from: [PlanetInfo(name:"Planet1", url: "url1"), PlanetInfo(name:"Planet2", url: "url2")])
        XCTAssertNotNil(peopleUrls, "People Urls shouldnt be nil")
        XCTAssertTrue(peopleUrls.isEmpty, "People urls' count should be 0")
    }
    
    func testPeopleUrlsWithTwoPlanetInfoAndOneResidentUrl() {
        let peopleUrls = PlanetsHelper.peopleUrls(from: [PlanetInfo(name:"Planet1", url: "url1"), PlanetInfo(name:"Planet2", residents: ["personUrl1"], url: "url2")])
        XCTAssertNotNil(peopleUrls, "People Urls shouldnt be nil")
        XCTAssertTrue(peopleUrls.count == 1, "People urls' count should be 1")
        XCTAssertTrue(peopleUrls == ["personUrl1"], "Expected person urls is wrong")
    }
    
    func testPeopleUrlsWithTwoPlanetInfoAndMultipleResidentUrl() {
        let peopleUrls = PlanetsHelper.peopleUrls(from: [PlanetInfo(name:"Planet1", residents: ["personUrl2"], url: "url1"), PlanetInfo(name:"Planet2", residents: ["personUrl1", "personUrl3"], url: "url2")])
        XCTAssertNotNil(peopleUrls, "People Urls shouldnt be nil")
        XCTAssertTrue(peopleUrls.count == 3, "People urls' count should be 3")
        XCTAssertTrue(peopleUrls == ["personUrl2", "personUrl1", "personUrl3"], "Expected person urls is wrong")
    }

    func testFilmUrlsWithEmptyPlanetInfo() {
        let filmUrls = PlanetsHelper.filmUrls(from: [])
        XCTAssertNotNil(filmUrls, "Film Urls shouldnt be nil")
        XCTAssertTrue(filmUrls.isEmpty, "Film urls' count should be 0")
    }

    func testFilmUrlsWithSinglePlanetInfoAndValidFilmUrl() {
        let filmUrls = PlanetsHelper.filmUrls(from: [PlanetInfo(name:"Planet1", films: ["filmUrl1"], url: "url1")])
        XCTAssertNotNil(filmUrls, "Film Urls shouldnt be nil")
        XCTAssertTrue(filmUrls.count == 1, "Film urls' count should be 1")
        XCTAssertTrue(filmUrls == ["filmUrl1"], "Expected Film urls is wrong")
    }
    
    func testFilmUrlsWithSinglePlanetInfoAndNilFilmUrl() {
        let filmUrls = PlanetsHelper.filmUrls(from: [PlanetInfo(name:"Planet1", url: "url1")])
        XCTAssertNotNil(filmUrls, "Film Urls shouldnt be nil")
        XCTAssertTrue(filmUrls.isEmpty, "Film urls' count should be 0")
    }
    
    func testFilmUrlsWithSinglePlanetInfoAndTwoFilmUrl() {
        let filmUrls = PlanetsHelper.filmUrls(from: [PlanetInfo(name:"Planet1", films: ["filmUrl1", "filmUrl2"], url: "url1")])
        XCTAssertNotNil(filmUrls, "Film Urls should not be nil")
        XCTAssertTrue(filmUrls.count == 2, "Film urls' count should be 2")
        XCTAssertTrue(filmUrls == ["filmUrl1", "filmUrl2"], "Expected Film urls is wrong")
    }

    func testFilmUrlsWithTwoPlanetInfoAndNoFilmUrl() {
        let filmUrls = PlanetsHelper.filmUrls(from: [PlanetInfo(name:"Planet1", url: "url1"), PlanetInfo(name:"Planet2", url: "url2")])
        XCTAssertNotNil(filmUrls, "Film Urls shouldnt be nil")
        XCTAssertTrue(filmUrls.isEmpty, "Film urls' count should be 0")
    }
    
    func testFilmUrlsWithTwoPlanetInfoAndOneFilmUrl() {
        let filmUrls = PlanetsHelper.filmUrls(from: [PlanetInfo(name:"Planet1", url: "url1"), PlanetInfo(name:"Planet2", films: ["filmUrl1"], url: "url2")])
        XCTAssertNotNil(filmUrls, "Film Urls shouldnt be nil")
        XCTAssertTrue(filmUrls.count == 1, "Film urls' count should be 1")
        XCTAssertTrue(filmUrls == ["filmUrl1"], "Expected Film urls is wrong")
    }
    
    func testFilmUrlsWithTwoPlanetInfoAndMultipleFilmUrl() {
        let filmUrls = PlanetsHelper.filmUrls(from: [PlanetInfo(name:"Planet1", films: ["filmUrl2"], url: "url1"), PlanetInfo(name:"Planet2", films: ["filmUrl1", "filmUrl3"], url: "url2")])
        XCTAssertNotNil(filmUrls, "Film Urls shouldnt be nil")
        XCTAssertTrue(filmUrls.count == 3, "Film urls' count should be 3")
        XCTAssertTrue(filmUrls == ["filmUrl2", "filmUrl1", "filmUrl3"], "Expected Film urls is wrong")
    }
}
