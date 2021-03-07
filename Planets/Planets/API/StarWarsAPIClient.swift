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
    case internalServerError = 503
}

enum HTTPHeaderKey: String {
    case etag = "Etag"
    case ifNoneMatch = "If-None-Match"
}

protocol StarWarsAPIClientProtocol {
    var peopleListGroup: DispatchGroup { get }
    var filmListGroup: DispatchGroup { get }
    var planetsDataFetchSuccess:(([PlanetInfo]?, Bool?) -> Void)? { get set }
    var planetsDataFetchFailure:((Error?) -> Void)? { get set }
    func fetchPlanetList(fullFetch: Bool)
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
    
    let urlSession: URLSession
    var peopleListGroup = DispatchGroup()
    var filmListGroup = DispatchGroup()
    var planetsDataFetchSuccess: (([PlanetInfo]?, Bool?) -> Void)?
    var planetsDataFetchFailure: ((Error?) -> Void)?
    var personDataFetchSuccess:((PeopleInfo?) -> Void)?
    var personDataFetchFailure:((Error?) -> Void)?
    var peopleDataFetchComplete:(() -> Void)?
    var filmDataFetchSuccess:((FilmInfo?) -> Void)?
    var filmDataFetchFailure:((Error?) -> Void)?
    var filmDataFetchComplete:(() -> Void)?

    static let kETagUserDefaultsKey = "eTagUDKey"
    static let starWarsPlanetsAPI = "https://swapi.dev/api/planets/"

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchPlanetList(fullFetch: Bool = false) {

        NSLog(#function)

        guard let url = URL(string: StarWarsAPIClient.starWarsPlanetsAPI) else {
            print("Unable to create an instance for the given Planets URL")
            self.planetsDataFetchFailure?(nil)
            return
        }

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringCacheData,
                                    timeoutInterval: 120)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Accept", forHTTPHeaderField: "Vary")

        if fullFetch == false, let eTagValue = UserDefaults.standard.string(forKey: StarWarsAPIClient.kETagUserDefaultsKey) {
            urlRequest.addValue(eTagValue, forHTTPHeaderField: HTTPHeaderKey.ifNoneMatch.rawValue)
        }

        let task = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in

            if let response = urlResponse as? HTTPURLResponse {
                if response.statusCode == HTTPStatusCodes.notModified.rawValue {
                    NSLog("No new data to be downloaded and saved.")
                    self.planetsDataFetchSuccess?(nil, false)
                    return
                } else if response.statusCode == HTTPStatusCodes.success.rawValue {
                    NSLog("Save the eTag value for future use.")
                    if let eTagValue = response.value(forHTTPHeaderField: HTTPHeaderKey.etag.rawValue) {
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

            if let jsonData = data, jsonData.isEmpty == false {
                let parsedPlanetData = StarWarsAPIParser.parsePlanetListResponse(with: jsonData)
                self.planetsDataFetchSuccess?(parsedPlanetData, fullFetch)
                return
            }
            
            self.planetsDataFetchSuccess?(nil, false)
        }

        task.resume()
    }

    func fetchPersonDetails(with urlList: [String]) {

        urlList.forEach { urlString in
            guard let url = URL(string: urlString) else {
                print("Unable to create an instance for the given Person URL")
                return
            }

            peopleListGroup.enter()
            var urlRequest = URLRequest(url: url,
                                        cachePolicy: .reloadIgnoringCacheData,
                                        timeoutInterval: 120)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Accept", forHTTPHeaderField: "Vary")

            let task = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in

                if let error = error {
                    self.personDataFetchFailure?(error)
                    self.peopleListGroup.leave()
                    return
                }

                if let jsonData = data, jsonData.isEmpty == false {
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

            guard let url = URL(string: urlString) else {
                print("Unable to create an instance for the given Film URL")
                return
            }

            filmListGroup.enter()
            var urlRequest = URLRequest(url: url,
                                        cachePolicy: .reloadIgnoringCacheData,
                                        timeoutInterval: 120)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Accept", forHTTPHeaderField: "Vary")

            let task = urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in

                if let error = error {
                    self.filmDataFetchFailure?(error)
                    self.filmListGroup.leave()
                    return
                }

                if let jsonData = data, jsonData.isEmpty == false {
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
