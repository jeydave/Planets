//
//  PlanetsViewModel.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import Foundation

class PlanetsViewModel {

    var apiClient: StarWarsAPIClientProtocol
    var dataStore: DataStore

    init(with apiClient: StarWarsAPIClientProtocol = StarWarsAPIClient(), and dataStore: DataStore = DataStore()) {
        self.apiClient = apiClient
        self.dataStore = dataStore
        initializeClosures()
    }

    var planetsDataFetchComplete: (([PlanetInfo]) -> Void)?
    var updateUI: (() -> Void)?
    var displayError: ((Error?) -> Void)?
    let peopleFilmDispatchGroup = DispatchGroup()

    func initializeClosures() {

        apiClient.planetsDataFetchSuccess = { [weak self] (planetsInfo, fullFetch) in
            guard let planetListInfo = planetsInfo, planetListInfo.isEmpty == false else {
                self?.displayError?(nil)
                return
            }

            if let fullFetch = fullFetch, fullFetch == true {
                self?.dataStore.deleteAllData()
            }
            
            self?.dataStore.save(planets: planetListInfo)
            self?.planetsDataFetchComplete?(planetListInfo)
        }

        apiClient.planetsDataFetchFailure = { [weak self] (error: Error?) in
            self?.displayError?(error)
        }

        apiClient.personDataFetchSuccess = { [weak self] personInfo in
            DispatchQueue.main.async {
                self?.dataStore.save(personInfo: personInfo)
            }
        }

        apiClient.personDataFetchFailure = { [weak self] (error: Error?) in
            DispatchQueue.main.async {
                self?.displayError?(error)
            }
        }

        apiClient.filmDataFetchSuccess = { [weak self] filmInfo in
            DispatchQueue.main.async {
                self?.dataStore.save(filmInfo: filmInfo)
            }
        }

        apiClient.filmDataFetchFailure = { [weak self] (error: Error?) in
            DispatchQueue.main.async {
                self?.displayError?(error)
            }
        }

        apiClient.peopleDataFetchComplete = { [weak self] in
            NSLog("Fetched all the people data")
            self?.peopleFilmDispatchGroup.leave()
        }

        apiClient.filmDataFetchComplete = { [weak self] in
            NSLog("Fetched all the film data")
            self?.peopleFilmDispatchGroup.leave()
        }
    }

    /**
     The func that supplies data to the View Controller
     - Parameters:
        - sortField: A string containing the attribute name with which the data source can be sorted. Default value is `created`
        - filter: NSPredicate with the condition to filter out the results. Can be nil.
     - Returns: An array of `PlanetInfo` objects if present or nil
    */
    func planetDatasource(with sortField: String = "created", filter: NSPredicate? = nil) -> [PlanetInfo]? {
        return dataStore.readPlanetInfo(sortField: sortField, filter: filter)
    }

    /**
     The func to fetch the planet details from the server
     
     - Parameter fullFetch: If true, Etag info will be ignored. If false and Etag is available, Etag will be added to the If-None-Match header to check if updates are available.
    */
    func fetchPlanetDetails(fullFetch: Bool) {
        apiClient.fetchPlanetList(fullFetch: fullFetch)
    }
    
    func fetchPeopleAndFilms(for planetsInfo: [PlanetInfo]) {

        peopleFilmDispatchGroup.enter()
        self.fetchPeopleList(planetsInfo)

        peopleFilmDispatchGroup.enter()
        self.fetchFilmList(planetsInfo)

        peopleFilmDispatchGroup.notify(queue: .main) {
            NSLog("People and films data fetched successfully")
            self.updateUI?()
        }
    }

}

//MARK: - Private Methods
extension PlanetsViewModel {
    
    private func fetchPeopleList(_ planetInfo: [PlanetInfo]) {
        let peopleUrlList = Array(Set(PlanetsHelper.peopleUrls(from: planetInfo)))
        NSLog("People Urls: \(peopleUrlList)")
        apiClient.fetchPersonDetails(with: peopleUrlList)
    }

    private func fetchFilmList(_ planetInfo: [PlanetInfo]) {
        let filmUrlList = Array(Set(PlanetsHelper.filmUrls(from: planetInfo)))
        NSLog("Film Urls: \(filmUrlList)")
        apiClient.fetchFilmDetails(with: filmUrlList)
    }
}
