//
//  PlanetsViewModelTests.swift
//  PlanetsTests
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import XCTest
@testable import Planets

class PlanetsViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSinglePlanetDetailsWithDefaultParams() {
        let viewModel = PlanetsViewModel()
        viewModel.dataStore = SingleDataMockDataStore()
        let planetInfoList = viewModel.planetDatasource()
        XCTAssertTrue(planetInfoList?.count == 1, "Planet info list shouldnt be empty and count should be 1.")
        XCTAssertTrue(planetInfoList![0].name == "planet1", "Planet name is wrong")
    }

    func testMultiPlanetDetailsWithDefaultParams() {
        let viewModel = PlanetsViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let planetInfoList = viewModel.planetDatasource()
        XCTAssertTrue(planetInfoList?.count == 10, "Planet info list shouldnt be empty and count should be 1.")
        let planetNames = ["planet7", "planet1", "planet2", "planet5", "planet6", "planet10", "planet9", "planet4", "planet3", "planet8"]
        let fetchedPlanetNames = planetInfoList?.compactMap { $0.name }
        XCTAssertTrue(planetNames == fetchedPlanetNames, "Planet data source returned is wrong")
    }
    
    func testMultiPlanetDetailsWithNameSorting() {
        let viewModel = PlanetsViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let planetInfoList = viewModel.planetDatasource(with: "name")
        XCTAssertTrue(planetInfoList?.count == 10, "Planet info list shouldnt be empty and count should be 1.")
        let planetNames = ["planet1", "planet2", "planet3", "planet4", "planet5", "planet6", "planet7", "planet8", "planet9", "planet10"]
        let fetchedPlanetNames = planetInfoList?.compactMap { $0.name }
        XCTAssertTrue(planetNames == fetchedPlanetNames, "Planet data source returned is wrong")
    }
    
    func testMultiPlanetDetailsWithDiameterSorting() {
        let viewModel = PlanetsViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let planetInfoList = viewModel.planetDatasource(with: "diameter")
        XCTAssertTrue(planetInfoList?.count == 10, "Planet info list shouldnt be empty and count should be 1.")
        let planetNames = ["planet1", "planet3", "planet4", "planet5", "planet6", "planet7", "planet8", "planet9", "planet10", "planet2"]
        let fetchedPlanetNames = planetInfoList?.compactMap { $0.name }
        XCTAssertTrue(planetNames == fetchedPlanetNames, "Planet data source returned is wrong")
    }
    
    func testMultiPlanetDetailsWithPopulationSorting() {
        let viewModel = PlanetsViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let planetInfoList = viewModel.planetDatasource(with: "population")
        XCTAssertTrue(planetInfoList?.count == 10, "Planet info list shouldnt be empty and count should be 1.")
        let planetNames = ["planet10", "planet9", "planet3", "planet8", "planet4", "planet6", "planet5", "planet2", "planet1", "planet7"]
        let fetchedPlanetNames = planetInfoList?.compactMap { $0.name }
        XCTAssertTrue(planetNames == fetchedPlanetNames, "Planet data source returned is wrong")
    }
    
    func testSinglePlanetDetailsWithNoFilterResults() {
        let viewModel = PlanetsViewModel()
        viewModel.dataStore = SingleDataMockDataStore()
        let predicate = NSPredicate(format: "terrain CONTAINS[c] 'mountain'")
        let planetInfoList = viewModel.planetDatasource(filter: predicate)
        XCTAssertNotNil(planetInfoList, "Planet info list should not be nil")
        XCTAssertTrue(planetInfoList?.count == 0, "Planet info list count should be 0")
    }

    func testSinglePlanetDetailsWithFilterResults() {
        let viewModel = PlanetsViewModel()
        viewModel.dataStore = SingleDataMockDataStore()
        let predicate = NSPredicate(format: "terrain CONTAINS[c] 'rocky'")
        let planetInfoList = viewModel.planetDatasource(filter: predicate)
        XCTAssertNotNil(planetInfoList, "Planet info list should not be nil")
        XCTAssertTrue(planetInfoList?.count == 1, "Planet info list count should be 1")
    }

    func testMultiPlanetDetailsWithNoFilterResults() {
        let viewModel = PlanetsViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let predicate = NSPredicate(format: "terrain CONTAINS[c] 'sand'")
        let planetInfoList = viewModel.planetDatasource(filter: predicate)
        XCTAssertNotNil(planetInfoList, "Planet info list should not be nil")
        XCTAssertTrue(planetInfoList?.count == 0, "Planet info list count should be 0")
    }

    func testMultiPlanetDetailsWithFilterResults() {
        let viewModel = PlanetsViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let predicate = NSPredicate(format: "terrain CONTAINS[c] 'rocky'")
        let planetInfoList = viewModel.planetDatasource(filter: predicate)
        XCTAssertNotNil(planetInfoList, "Planet info list should not be nil")
        XCTAssertTrue(planetInfoList?.count == 3, "Planet info list count should be 3")
    }
    
    func testFetchPlanetDetailsSuccessScenario() {
        
        let viewModel = PlanetsViewModel(with: SuccessMockStarWarsAPIClient(), and: SingleDataMockDataStore())
        let expectation = XCTestExpectation(description: "Expectation to check if all the data fetch was successful.")
        viewModel.planetsDataFetchComplete = { _ in
            viewModel.fetchPeopleAndFilms(for: [])
        }
        
        viewModel.apiClient.peopleDataFetchComplete = {
            viewModel.peopleFilmDispatchGroup.leave()
        }

        viewModel.apiClient.filmDataFetchComplete = {
            viewModel.peopleFilmDispatchGroup.leave()
        }
        
        viewModel.updateUI = {
            expectation.fulfill()
        }
        
        viewModel.fetchPlanetDetails(fullFetch: false)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchPlanetDetailsPlanetListNilScenario() {
        
        let viewModel = PlanetsViewModel(with: NilPlanetListMockStarWarsAPIClient(), and: SingleDataMockDataStore())
        let expectation = XCTestExpectation(description: "Expectation to check if all the data fetch was successful.")

        viewModel.displayError = { _ in
            expectation.fulfill()
        }
        
        viewModel.fetchPlanetDetails(fullFetch: false)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchPlanetDetailsPlanetListEmptyScenario() {
        
        let viewModel = PlanetsViewModel(with: EmptyPlanetListMockStarWarsAPIClient(), and: SingleDataMockDataStore())
        let expectation = XCTestExpectation(description: "Expectation to check if all the data fetch was successful.")

        viewModel.displayError = { _ in
            expectation.fulfill()
        }
        
        viewModel.fetchPlanetDetails(fullFetch: false)
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchPlanetDetailsWithPlanetFetchFailureScenario() {
        
        let viewModel = PlanetsViewModel(with: PlanetFetchFailureMockStarWarsAPIClient(), and: SingleDataMockDataStore())
        let updateUIExpectation = XCTestExpectation(description: "Expectation to check if Update UI is called.")
        updateUIExpectation.isInverted = true
        let displayErrorExpectation = XCTestExpectation(description: "Expectation to check if Display error is called")
        viewModel.planetsDataFetchComplete = { _ in
            viewModel.fetchPeopleAndFilms(for: [])
        }
        
        viewModel.apiClient.peopleDataFetchComplete = {
            viewModel.peopleFilmDispatchGroup.leave()
        }

        viewModel.apiClient.filmDataFetchComplete = {
            viewModel.peopleFilmDispatchGroup.leave()
        }

        viewModel.updateUI = {
            updateUIExpectation.fulfill()
        }
        
        viewModel.displayError = { _ in
            displayErrorExpectation.fulfill()
        }
        
        viewModel.fetchPlanetDetails(fullFetch: false)
        wait(for: [updateUIExpectation, displayErrorExpectation], timeout: 5.0)
    }
    
    func testFetchPlanetDetailsWithPersonFetchFailureScenario() {
        
        let viewModel = PlanetsViewModel(with: PersonFetchFailureMockStarWarsAPIClient(), and: SingleDataMockDataStore())
        let updateUIExpectation = XCTestExpectation(description: "Expectation to check if Update UI is called.")
        let displayErrorExpectation = XCTestExpectation(description: "Expectation to check if Display error is called")
        viewModel.planetsDataFetchComplete = { _ in
            viewModel.fetchPeopleAndFilms(for: [])
        }
        
        viewModel.apiClient.peopleDataFetchComplete = {
            viewModel.peopleFilmDispatchGroup.leave()
        }

        viewModel.apiClient.filmDataFetchComplete = {
            viewModel.peopleFilmDispatchGroup.leave()
        }

        viewModel.updateUI = {
            updateUIExpectation.fulfill()
        }
        
        viewModel.displayError = { _ in
            displayErrorExpectation.fulfill()
        }
        
        viewModel.fetchPlanetDetails(fullFetch: false)
        wait(for: [updateUIExpectation, displayErrorExpectation], timeout: 5.0)
    }
    
    func testFetchPlanetDetailsWithFilmFetchFailureScenario() {
        
        let viewModel = PlanetsViewModel(with: FilmFetchFailureMockStarWarsAPIClient(), and: SingleDataMockDataStore())
        let updateUIExpectation = XCTestExpectation(description: "Expectation to check if Update UI is called.")
        let displayErrorExpectation = XCTestExpectation(description: "Expectation to check if Display error is called")
        viewModel.planetsDataFetchComplete = { _ in
            viewModel.fetchPeopleAndFilms(for: [])
        }
        
        viewModel.apiClient.peopleDataFetchComplete = {
            viewModel.peopleFilmDispatchGroup.leave()
        }

        viewModel.apiClient.filmDataFetchComplete = {
            viewModel.peopleFilmDispatchGroup.leave()
        }

        viewModel.updateUI = {
            updateUIExpectation.fulfill()
        }
        
        viewModel.displayError = { _ in
            displayErrorExpectation.fulfill()
        }
        
        viewModel.fetchPlanetDetails(fullFetch: false)
        wait(for: [updateUIExpectation, displayErrorExpectation], timeout: 5.0)
    }
}
