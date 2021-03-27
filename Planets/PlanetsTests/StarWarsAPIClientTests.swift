//
//  StarWarsAPIClientTests.swift
//  PlanetsTests
//
//  Created by Andrew on 07/03/21.
//

import XCTest
@testable import Planets

enum TestError: Error {
    case testFailure
}

class StarWarsAPIClientTests: XCTestCase {

    var apiClient: StarWarsAPIClient!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let urlConfig = URLSessionConfiguration.default
        urlConfig.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: urlConfig, delegate: self, delegateQueue: nil)
        apiClient = StarWarsAPIClient(urlSession: urlSession)
        UserDefaults.standard.removeObject(forKey: StarWarsAPIClient.kETagUserDefaultsKey)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        UserDefaults.standard.removeObject(forKey: StarWarsAPIClient.kETagUserDefaultsKey)
    }
}

extension StarWarsAPIClientTests: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
}

//MARK:- FetchPlanetList API Tests
extension StarWarsAPIClientTests {
    
    func testFetchPlanetSuccessfulResponseWithValidResults() {
        
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        failureCallbackExpectation.isInverted = true
        
        let jsonData = """
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
        """.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.success.rawValue, httpVersion: nil, headerFields: ["Etag": "MockedETagValue"])!
            return (response, jsonData, nil)
        }
        
        apiClient.planetsDataFetchSuccess = { (planetsInfo, _) in
            XCTAssertNotNil(planetsInfo, "Planets info should not be nil")
            XCTAssertTrue(planetsInfo?.count == 2, "Correct planetsInfo is not received")
            XCTAssertTrue(UserDefaults.standard.string(forKey: StarWarsAPIClient.kETagUserDefaultsKey) == "MockedETagValue", "ETag value is not stored properly.")
            successCallbackExpectation.fulfill()
        }
        
        apiClient.planetsDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.fetchPlanetList()
        wait(for: [successCallbackExpectation, failureCallbackExpectation], timeout: 5.0)
    }
    
    func testFetchPlanetSuccessfulResponseWithNoResults() {
        
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        failureCallbackExpectation.isInverted = true
        
        let jsonData = """
            {
                "count": 60,
                "next": "http://swapi.dev/api/planets/?page=2",
                "previous": null,
                "results": []
            }
        """.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.success.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, jsonData, nil)
        }
        
        apiClient.planetsDataFetchSuccess = { (planetsInfo, _) in
            XCTAssertNil(planetsInfo, "Planets info should be nil for no results")
            successCallbackExpectation.fulfill()
        }
        
        apiClient.planetsDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.fetchPlanetList()
        wait(for: [successCallbackExpectation, failureCallbackExpectation], timeout: 5.0)
    }

    func testFetchPlanetSuccessfulResponseWithEmptyData() {
        
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        failureCallbackExpectation.isInverted = true
        
        let jsonData = "".data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.success.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, jsonData, nil)
        }
        
        apiClient.planetsDataFetchSuccess = { (planetsInfo, _) in
            XCTAssertNil(planetsInfo, "Planets info should be nil for empty data")
            successCallbackExpectation.fulfill()
        }
        
        apiClient.planetsDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.planetsDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.fetchPlanetList()
        wait(for: [successCallbackExpectation, failureCallbackExpectation], timeout: 5.0)
    }
    
    func testFetchPlanetFailureResponse() {
        
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        successCallbackExpectation.isInverted = true
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 0, httpVersion: nil, headerFields: nil)!
            return (response, nil, TestError.testFailure)
        }
        
        apiClient.planetsDataFetchSuccess = { (_, _) in
            successCallbackExpectation.fulfill()
        }
        
        apiClient.planetsDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.fetchPlanetList()
        wait(for: [successCallbackExpectation, failureCallbackExpectation], timeout: 5.0)
    }
    
    func testFetchPlanetNotModifiedResponse() {
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        failureCallbackExpectation.isInverted = true
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.notModified.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, nil, nil)
        }
        
        apiClient.planetsDataFetchSuccess = { (planetsInfo, _) in
            XCTAssertNil(planetsInfo, "Planets info should be nil for Not modified response")
            successCallbackExpectation.fulfill()
        }
        
        apiClient.planetsDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.fetchPlanetList()
        wait(for: [successCallbackExpectation, failureCallbackExpectation], timeout: 5.0)
    }
    
    func testFetchPlanetOtherResponse() {
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        failureCallbackExpectation.isInverted = true
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.internalServerError.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, nil, nil)
        }
        
        apiClient.planetsDataFetchSuccess = { (planetsInfo, _) in
            XCTAssertNil(planetsInfo, "Planets info should be nil for Internal Server error response")
            successCallbackExpectation.fulfill()
        }
        
        apiClient.planetsDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.fetchPlanetList()
        wait(for: [successCallbackExpectation, failureCallbackExpectation], timeout: 5.0)
    }
}

//MARK:- FetchPersonDetails API Tests
extension StarWarsAPIClientTests {
    
    func testFetchPersonDetailsSuccessResponse() {
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        failureCallbackExpectation.isInverted = true
        let completeCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response completion")
        
        let jsonData = """
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
        """.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.success.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, jsonData, nil)
        }
        
        apiClient.personDataFetchSuccess = { personInfo in
            XCTAssertNotNil(personInfo, "Person info should not be nil for Success response")
            XCTAssertTrue(personInfo?.name == "Luke Skywalker", "Person info is wrong")
            successCallbackExpectation.fulfill()
        }
        
        apiClient.personDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.peopleDataFetchComplete = {
            completeCallbackExpectation.fulfill()
        }
        
        apiClient.fetchPersonDetails(with: ["https://swapi.dev/api/people/1/"])
        wait(for: [successCallbackExpectation, failureCallbackExpectation, completeCallbackExpectation], timeout: 5.0)
    }
    
    func testFetchPersonDetailsWithNilData() {
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        successCallbackExpectation.isInverted = true
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        failureCallbackExpectation.isInverted = true
        let completeCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response completion")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.success.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, nil, nil)
        }
        
        apiClient.personDataFetchSuccess = { personInfo in
            successCallbackExpectation.fulfill()
        }
        
        apiClient.personDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.peopleDataFetchComplete = {
            completeCallbackExpectation.fulfill()
        }
        
        apiClient.fetchPersonDetails(with: ["https://swapi.dev/api/people/1/"])
        wait(for: [successCallbackExpectation, failureCallbackExpectation, completeCallbackExpectation], timeout: 5.0)
    }
    
    func testFetchPersonDetailsFailureResponse() {
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        successCallbackExpectation.isInverted = true
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        let completeCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response completion")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.internalServerError.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, nil, TestError.testFailure)
        }
        
        apiClient.personDataFetchSuccess = { personInfo in
            successCallbackExpectation.fulfill()
        }
        
        apiClient.personDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.peopleDataFetchComplete = {
            completeCallbackExpectation.fulfill()
        }
        
        apiClient.fetchPersonDetails(with: ["https://swapi.dev/api/people/1/"])
        wait(for: [successCallbackExpectation, failureCallbackExpectation, completeCallbackExpectation], timeout: 5.0)
    }
}

//MARK:- FetchFilmDetails API Tests
extension StarWarsAPIClientTests {
    
    func testFetchFilmDetailsSuccessResponse() {
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        failureCallbackExpectation.isInverted = true
        let completeCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response completion")
        
        let jsonData = """
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
        """.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.success.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, jsonData, nil)
        }
        
        apiClient.filmDataFetchSuccess = { filmInfo in
            XCTAssertNotNil(filmInfo, "Person info should not be nil for Success response")
            XCTAssertTrue(filmInfo?.title == "A New Hope", "Person info is wrong")
            successCallbackExpectation.fulfill()
        }
        
        apiClient.filmDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.filmDataFetchComplete = {
            completeCallbackExpectation.fulfill()
        }
        
        apiClient.fetchFilmDetails(with: ["https://swapi.dev/api/films/1/"])
        wait(for: [successCallbackExpectation, failureCallbackExpectation, completeCallbackExpectation], timeout: 5.0)
    }
    
    func testFetchFilmDetailsWithNilData() {
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        successCallbackExpectation.isInverted = true
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        failureCallbackExpectation.isInverted = true
        let completeCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response completion")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.success.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, nil, nil)
        }
        
        apiClient.filmDataFetchSuccess = { personInfo in
            successCallbackExpectation.fulfill()
        }
        
        apiClient.filmDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.filmDataFetchComplete = {
            completeCallbackExpectation.fulfill()
        }
        
        apiClient.fetchFilmDetails(with: ["https://swapi.dev/api/films/1/"])
        wait(for: [successCallbackExpectation, failureCallbackExpectation, completeCallbackExpectation], timeout: 5.0)
    }
    
    func testFetchFilmDetailsFailureResponse() {
        let successCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response")
        successCallbackExpectation.isInverted = true
        let failureCallbackExpectation = XCTestExpectation(description: "Expectation to check for Failure in API response")
        let completeCallbackExpectation = XCTestExpectation(description: "Expectation to check for API response completion")
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: HTTPStatusCodes.internalServerError.rawValue, httpVersion: nil, headerFields: nil)!
            return (response, nil, TestError.testFailure)
        }
        
        apiClient.filmDataFetchSuccess = { personInfo in
            successCallbackExpectation.fulfill()
        }
        
        apiClient.filmDataFetchFailure = { _ in
            failureCallbackExpectation.fulfill()
        }
        
        apiClient.filmDataFetchComplete = {
            completeCallbackExpectation.fulfill()
        }
        
        apiClient.fetchFilmDetails(with: ["https://swapi.dev/api/films/1/"])
        wait(for: [successCallbackExpectation, failureCallbackExpectation, completeCallbackExpectation], timeout: 5.0)
    }
}
