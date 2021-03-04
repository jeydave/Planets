//
//  PlanetsViewModel.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import Foundation

class PlanetsViewModel {

    var apiClient: StarWarsAPIClientProtocol = StarWarsAPIClient()

    init() {
        initializeClosures()
    }

    var hideHUD: (() -> Void)?
    var updateUI: (() -> Void)?
    var displayError: ((Error?) -> Void)?
    let peopleFilmDispatchGroup = DispatchGroup()

    func initializeClosures() {

        apiClient.planetsDataFetchSuccess = { [weak self] planetsInfo in
            guard let planetListInfo = planetsInfo, planetListInfo.isEmpty == false else {
                self?.hideHUD?()
                return
            }

            DataStore.shared.save(planets: planetListInfo)
            self?.fetchPeopleAndFilms(for: planetListInfo)
        }

        apiClient.planetsDataFetchFailure = { [weak self] (error: Error?) in
            self?.displayError?(error)
        }

        apiClient.personDataFetchSuccess = { personInfo in
            DispatchQueue.main.async {
                DataStore.shared.save(personInfo: personInfo)
            }
        }

        apiClient.personDataFetchFailure = { [weak self] (error: Error?) in
            DispatchQueue.main.async {
                self?.displayError?(error)
            }
        }

        apiClient.filmDataFetchSuccess = { filmInfo in
            DispatchQueue.main.async {
                DataStore.shared.save(filmInfo: filmInfo)
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
            NSLog("Fetched all the people data")
            self?.peopleFilmDispatchGroup.leave()
        }
    }

    func planetDatasource(with sortField: String = "created", filter: NSPredicate? = nil) -> [PlanetInfo]? {
        return DataStore.shared.fetchPlanetInfo(sortField: sortField, filter: filter)
    }

    func fetchPlanetDetails() {
        apiClient.fetchPlanetList()
    }

    private func fetchPeopleAndFilms(for planetsInfo: [PlanetInfo]) {

        peopleFilmDispatchGroup.enter()
        self.fetchPeopleList(planetsInfo)

        peopleFilmDispatchGroup.enter()
        self.fetchFilmList(planetsInfo)

        peopleFilmDispatchGroup.notify(queue: .main) {
            NSLog("People and films data fetched successfully")
            self.updateUI?()
        }
    }

    private func fetchPeopleList(_ planetInfo: [PlanetInfo]) {
        let peopleUrlList = Array(Set(peopleUrls(from: planetInfo)))
        NSLog("People Urls: \(peopleUrlList)")
        apiClient.fetchPersonDetails(with: peopleUrlList)
    }

    private func fetchFilmList(_ planetInfo: [PlanetInfo]) {
        let filmUrlList = Array(Set(filmUrls(from: planetInfo)))
        NSLog("Film Urls: \(filmUrlList)")
        apiClient.fetchFilmDetails(with: filmUrlList)
    }

    private func peopleUrls(from planetsInfo: [PlanetInfo]) -> [String] {
        return planetsInfo.compactMap { $0.residents }.reduce([], +)
    }

    private func filmUrls(from planetsInfo: [PlanetInfo]) -> [String] {
        return planetsInfo.compactMap { $0.films }.reduce([], +)
    }
}
