//
//  MockStarWarsAPIClient.swift
//  PlanetsTests
//
//  Created by Andrew on 05/03/21.
//

import Foundation
@testable import Planets

class MockStarWarsAPIClient: StarWarsAPIClientProtocol {
    
    var peopleListGroup = DispatchGroup()
    var filmListGroup = DispatchGroup()
    
    func fetchPlanetList(fullFetch: Bool) {
        
    }
    
    func fetchPersonDetails(with urlList: [String]) {
        
    }
    
    func fetchFilmDetails(with urlList: [String]) {
        
    }
    
    var planetsDataFetchSuccess: (([PlanetInfo]?, Bool?) -> Void)?
    
    var planetsDataFetchFailure: ((Error?) -> Void)?
    
    var personDataFetchSuccess: ((PeopleInfo?) -> Void)?
    
    var personDataFetchFailure: ((Error?) -> Void)?
    
    var peopleDataFetchComplete: (() -> Void)?
    
    var filmDataFetchSuccess: ((FilmInfo?) -> Void)?
    
    var filmDataFetchFailure: ((Error?) -> Void)?
    
    var filmDataFetchComplete: (() -> Void)?
}

class SuccessMockStarWarsAPIClient: MockStarWarsAPIClient {
    
    override func fetchPlanetList(fullFetch: Bool) {
        self.planetsDataFetchSuccess?([PlanetInfo(name: "Planet1", url: "planetUrl1")], fullFetch)
    }
    
    override func fetchPersonDetails(with urlList: [String]) {
        self.peopleListGroup.enter()
        self.personDataFetchSuccess?(PeopleInfo(name: "Person1", url: "PersonUrl1"))
        peopleListGroup.notify(queue: .main) {
            self.peopleDataFetchComplete?()
        }

        self.peopleListGroup.leave()
    }
    
    override func fetchFilmDetails(with urlList: [String]) {
        self.filmListGroup.enter()
        self.filmDataFetchSuccess?(FilmInfo(title: "Film1", url: "FilmUrl1"))
        peopleListGroup.notify(queue: .main) {
            self.filmDataFetchComplete?()
        }
        self.filmListGroup.leave()
    }
}

class NilPlanetListMockStarWarsAPIClient: MockStarWarsAPIClient {
    
    override func fetchPlanetList(fullFetch: Bool) {
        self.planetsDataFetchSuccess?(nil, fullFetch)
    }
}

class EmptyPlanetListMockStarWarsAPIClient: MockStarWarsAPIClient {
    
    override func fetchPlanetList(fullFetch: Bool) {
        self.planetsDataFetchSuccess?([], fullFetch)
    }
}

class PlanetFetchFailureMockStarWarsAPIClient: MockStarWarsAPIClient {
    
    override func fetchPlanetList(fullFetch: Bool) {
        self.planetsDataFetchFailure?(nil)
    }
}

class PersonFetchFailureMockStarWarsAPIClient: MockStarWarsAPIClient {
    
    override func fetchPlanetList(fullFetch: Bool) {
        self.planetsDataFetchSuccess?([PlanetInfo(name: "Planet1", url: "planetUrl1")], fullFetch)
    }
    
    override func fetchPersonDetails(with urlList: [String]) {
        self.peopleListGroup.enter()
        self.personDataFetchFailure?(nil)
        peopleListGroup.notify(queue: .main) {
            self.peopleDataFetchComplete?()
        }

        self.peopleListGroup.leave()
    }
    
    override func fetchFilmDetails(with urlList: [String]) {
        self.filmListGroup.enter()
        self.filmDataFetchSuccess?(FilmInfo(title: "Film1", url: "FilmUrl1"))
        peopleListGroup.notify(queue: .main) {
            self.filmDataFetchComplete?()
        }
        self.filmListGroup.leave()
    }
}

class FilmFetchFailureMockStarWarsAPIClient: MockStarWarsAPIClient {

    override func fetchPlanetList(fullFetch: Bool) {
        self.planetsDataFetchSuccess?([PlanetInfo(name: "Planet1", url: "planetUrl1")], fullFetch)
    }
    
    override func fetchPersonDetails(with urlList: [String]) {
        self.peopleListGroup.enter()
        self.personDataFetchSuccess?(PeopleInfo(name: "Person1", url: "PersonUrl1"))
        peopleListGroup.notify(queue: .main) {
            self.peopleDataFetchComplete?()
        }

        self.peopleListGroup.leave()
    }
    
    override func fetchFilmDetails(with urlList: [String]) {
        self.filmListGroup.enter()
        self.filmDataFetchFailure?(nil)
        peopleListGroup.notify(queue: .main) {
            self.filmDataFetchComplete?()
        }
        self.filmListGroup.leave()
    }
}
