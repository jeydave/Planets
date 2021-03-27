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
    
    /**
     The closure that will be called when Planets data fetch is successful
     */
    var planetsDataFetchSuccess:(([PlanetInfo]?, Bool?) -> Void)? { get set }
    
    /**
     The closure that will be called when Planets data fetch failed
     */
    var planetsDataFetchFailure:((Error?) -> Void)? { get set }
    
    /**
     The func that calls the Planets API and fetches the Planet list
     - Parameter fullFetch: The bool state to indicate if the API should use Etag value or not in the fetch
     */
    func fetchPlanetList(fullFetch: Bool)
    
    /**
     The closure that will be called when Resident data fetch is successful
     */
    var personDataFetchSuccess:((PeopleInfo?) -> Void)? { get set }
    
    /**
     The closure that will be called when Resident data fetch failed
     */
    var personDataFetchFailure:((Error?) -> Void)? { get set }
    
    /**
     The func that is used to call the Resident API and fetch the Resident Info
     - Parameters:
        - urlList: Provide the list of Resident URLs to be fetched from server
     */
    func fetchPersonDetails(with urlList: [String])
    
    /**
     The closure that will be called when all the Residents data in the Url list have been fetched
     */
    var peopleDataFetchComplete:(() -> Void)? { get set }
    
    /**
     The closure that will be called when Film data fetch is successful
     */
    var filmDataFetchSuccess:((FilmInfo?) -> Void)? { get set }
    
    /**
     The closure that will be called when Film data fetch failed
     */
    var filmDataFetchFailure:((Error?) -> Void)? { get set }
    
    /**
     The func that is used to call the Film API and fetch the Film Info
     - Parameters:
        - urlList: Provide the list of Film URLs to be fetched from server
     */
    func fetchFilmDetails(with urlList: [String])
    
    /**
     The closure that will be called when all the Films data in the Url list have been fetched
     */
    var filmDataFetchComplete:(() -> Void)? { get set }
}

class StarWarsAPIClient: NSObject, StarWarsAPIClientProtocol {
    
    var urlSession: URLSession?
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

    init(urlSession: URLSession? = nil) {
        super.init()
        
        if let session = urlSession {
            self.urlSession = session
        } else {
            self.urlSession = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: nil)
        }
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

        let task = urlSession?.dataTask(with: urlRequest) { (data, urlResponse, error) in

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

        task?.resume()
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

            let task = urlSession?.dataTask(with: urlRequest) { (data, urlResponse, error) in

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

            task?.resume()
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

            let task = urlSession?.dataTask(with: urlRequest) { (data, urlResponse, error) in

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

            task?.resume()
        }

        peopleListGroup.notify(queue: .main) {
            self.filmDataFetchComplete?()
        }
    }
}

extension StarWarsAPIClient: URLSessionDelegate {

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        NSLog(#function)
        
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
        let remoteCertificate = SecCertificateCopyData(certificate) as NSData
        
        guard let localCertPath = Bundle.main.path(forResource: "swapi.dev", ofType: ".der"),
              let localCertificate = NSData(contentsOfFile: localCertPath) as Data? else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        if isServerTrusted && remoteCertificate.isEqual(to: localCertificate) {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
            NSLog("Cert pinning complete for Session")
            return
        }
        
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
