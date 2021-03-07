//
//  PlanetInfoTableCellViewModelTests.swift
//  PlanetsTests
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import XCTest
@testable import Planets

class PlanetInfoTableCellViewModelTests: XCTestCase {

    let viewModel = PlanetInfoTableCellViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testResidentsTextWithNilUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        let residentsText = viewModel.residentsText(with: nil)
        XCTAssertTrue(residentsText == "Residents: None", "Residents text is wrong for nil input.")
    }
    
    func testResidentsTextWithSingleUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        viewModel.dataStore = SingleDataMockDataStore()
        let residentsText = viewModel.residentsText(with: ["PersonUrl1"])
        XCTAssertTrue(residentsText == "Residents: Person1", "Residents text is wrong for single input.")
    }

    func testResidentsTextWithUnknownUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        viewModel.dataStore = SingleDataMockDataStore()
        let residentsText = viewModel.residentsText(with: ["url1"])
        XCTAssertTrue(residentsText == "Residents: None", "Residents text is wrong for unknown input.")
    }

    func testResidentsTextWithTwoUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let residentsText = viewModel.residentsText(with: ["PersonUrl1", "PersonUrl2"])
        XCTAssertTrue(residentsText == "Residents: Person1, Person2", "Residents text is wrong for two url input.")
    }

    func testResidentsTextWithOneUnknownUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let residentsText = viewModel.residentsText(with: ["PersonUrl1", "url1"])
        XCTAssertTrue(residentsText == "Residents: Person1", "Residents text is wrong for two url input.")
    }
    
    func testResidentsTextWithTwoUnknownUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let residentsText = viewModel.residentsText(with: ["url2", "url1"])
        XCTAssertTrue(residentsText == "Residents: None", "Residents text is wrong for two url input.")
    }

    func testFilmsTextWithNilUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        let filmsText = viewModel.filmsText(with: nil)
        XCTAssertTrue(filmsText == "Films: None", "Films text is wrong for nil input.")
    }
    
    func testFilmsTextWithSingleUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        viewModel.dataStore = SingleDataMockDataStore()
        let filmsText = viewModel.filmsText(with: ["FilmUrl1"])
        XCTAssertTrue(filmsText == "Films: Film1", "Films text is wrong for single input.")
    }

    func testFilmsTextWithTwoUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let filmsText = viewModel.filmsText(with: ["FilmUrl1", "FilmUrl2"])
        XCTAssertTrue(filmsText == "Films: Film1, Film2", "Films text is wrong for two url input.")
    }
    
    func testFilmsTextWithOneUnknownUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let filmsText = viewModel.filmsText(with: ["FilmUrl1", "url1"])
        XCTAssertTrue(filmsText == "Films: Film1", "Films text is wrong for two url input.")
    }

    func testFilmsTextWithTwoUnknownUrlInput() {
        let viewModel = PlanetInfoTableCellViewModel()
        viewModel.dataStore = MultiDataMockDataStore()
        let filmsText = viewModel.filmsText(with: ["url1", "url2"])
        XCTAssertTrue(filmsText == "Films: None", "Films text is wrong for two url input.")
    }
}
