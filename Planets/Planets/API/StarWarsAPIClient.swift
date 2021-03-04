//
//  StarWarsAPIClient.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import Foundation

enum HTTPStatusCodes: Int {
    case success = 200
    case notModified = 304
}

protocol StarWarsAPIClientProtocol {
    var planetsDataFetchSuccess:(([PlanetInfo]?) -> Void)? { get set }
    var planetsDataFetchFailure:((Error?) -> Void)? { get set }
    func fetchPlanetList()
    var personDataFetchSuccess:((PeopleInfo?) -> Void)? { get set }
    var personDataFetchFailure:((Error?) -> Void)? { get set }
    func fetchPersonDetails(with urlList: [String])
    var peopleDataFetchComplete:(() -> Void)? { get set }
    var filmDataFetchSuccess:((FilmInfo?) -> Void)? { get set }
    var filmDataFetchFailure:((Error?) -> Void)? { get set }
    func fetchFilmDetails(with urlList: [String])
    var filmDataFetchComplete:(() -> Void)? { get set }
}

class StarWarsAPIClient: StarWarsAPIClientProtocol {
    var planetsDataFetchSuccess: (([PlanetInfo]?) -> Void)?
    var planetsDataFetchFailure: ((Error?) -> Void)?
    var personDataFetchSuccess:((PeopleInfo?) -> Void)?
    var personDataFetchFailure:((Error?) -> Void)?
    var peopleDataFetchComplete:(() -> Void)?
    var filmDataFetchSuccess:((FilmInfo?) -> Void)?
    var filmDataFetchFailure:((Error?) -> Void)?
    var filmDataFetchComplete:(() -> Void)?

    static let kETagUserDefaultsKey = "eTagUDKey"
    static let starWarsPlanetsAPI = "https://swapi.dev/api/planets/"

    var peopleListGroup = DispatchGroup()
    var filmListGroup = DispatchGroup()

    func fetchPlanetList() {

        NSLog(#function)

        guard let url = URL(string: StarWarsAPIClient.starWarsPlanetsAPI) else {
            print("Unable to create an instance for the given Planets URL")
            return
        }

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringCacheData,
                                    timeoutInterval: 120)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Accept", forHTTPHeaderField: "Vary")

        if let eTagValue = UserDefaults.standard.string(forKey: StarWarsAPIClient.kETagUserDefaultsKey) {
            urlRequest.addValue(eTagValue, forHTTPHeaderField: "If-None-Match")
        }

        let urlConfiguration = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: urlConfiguration)
        let task = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in

            if let response = urlResponse as? HTTPURLResponse {
                if response.statusCode == HTTPStatusCodes.notModified.rawValue {
                    NSLog("No new data to be downloaded and saved.")
                    self.planetsDataFetchSuccess?(nil)
                    return
                } else if response.statusCode == HTTPStatusCodes.success.rawValue {
                    NSLog("Save the eTag value for future use.")
                    if let eTagValue = response.value(forHTTPHeaderField: "Etag") {
                        NSLog("eTag - \(eTagValue)")
                        UserDefaults.standard.set(eTagValue, forKey: StarWarsAPIClient.kETagUserDefaultsKey)
                    }
                } else {
                    NSLog("Some other error - \(response)")
                }
            }

            if let error = error {
                self.planetsDataFetchFailure?(error)
                return
            }

            if let jsonData = data {
                let parsedPlanetData = StarWarsAPIParser.parsePlanetListResponse(with: jsonData)
                self.planetsDataFetchSuccess?(parsedPlanetData)
            }
        }

        task.resume()
    }

    func fetchPersonDetails(with urlList: [String]) {

        urlList.forEach { urlString in
            peopleListGroup.enter()
            guard let url = URL(string: urlString) else {
                print("Unable to create an instance for the given Person URL")
                return
            }

            var urlRequest = URLRequest(url: url,
                                        cachePolicy: .reloadIgnoringCacheData,
                                        timeoutInterval: 120)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Accept", forHTTPHeaderField: "Vary")

            let urlConfiguration = URLSessionConfiguration.default
            let urlSession = URLSession(configuration: urlConfiguration)
            let task = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in

                if let error = error {
                    self.personDataFetchFailure?(error)
                    self.peopleListGroup.leave()
                    return
                }

                if let jsonData = data {
                    let parsedPersonData = StarWarsAPIParser.parsePersonResponse(with: jsonData)
                    self.personDataFetchSuccess?(parsedPersonData)
                }

                self.peopleListGroup.leave()
            }

            task.resume()
        }

        peopleListGroup.notify(queue: .main) {
            self.peopleDataFetchComplete?()
        }
    }

    func fetchFilmDetails(with urlList: [String]) {

        urlList.forEach { urlString in
            filmListGroup.enter()

            guard let url = URL(string: urlString) else {
                print("Unable to create an instance for the given Film URL")
                return
            }

            var urlRequest = URLRequest(url: url,
                                        cachePolicy: .reloadIgnoringCacheData,
                                        timeoutInterval: 120)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Accept", forHTTPHeaderField: "Vary")

            let urlConfiguration = URLSessionConfiguration.default
            let urlSession = URLSession(configuration: urlConfiguration)
            let task = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in

                if let error = error {
                    self.filmDataFetchFailure?(error)
                    self.filmListGroup.leave()
                    return
                }

                if let jsonData = data {
                    let parsedFilmData = StarWarsAPIParser.parseFilmResponse(with: jsonData)
                    self.filmDataFetchSuccess?(parsedFilmData)
                }

                self.filmListGroup.leave()
            }

            task.resume()
        }

        peopleListGroup.notify(queue: .main) {
            self.filmDataFetchComplete?()
        }
    }
}
