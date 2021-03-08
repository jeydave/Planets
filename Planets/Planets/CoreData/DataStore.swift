//
//  DataStore.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import Foundation
import CoreData

class DataStore {

    let dataStoreContainer = DataStoreContainer.shared

    /**
     Deletes all the local data in DB
     */
    func deleteAllData() {
        let planetInfoRequest = Planets.planetsFetchRequest()
        let personInfoRequest = Person.personfetchRequest()
        let filmInfoRequest = Films.filmFetchRequest()
        
        do {
            let planetInfoList = try dataStoreContainer.viewContext().fetch(planetInfoRequest)
            for planetDetails in planetInfoList {
                dataStoreContainer.viewContext().delete(planetDetails)
            }
            
            let personInfoList = try dataStoreContainer.viewContext().fetch(personInfoRequest)
            for personDetails in personInfoList {
                dataStoreContainer.viewContext().delete(personDetails)
            }

            let filmInfoList = try dataStoreContainer.viewContext().fetch(filmInfoRequest)
            for filmDetails in filmInfoList {
                dataStoreContainer.viewContext().delete(filmDetails)
            }
        } catch {
            NSLog("Unable to fetch the planet info from the local DB.")
        }

    }

    /**
     Func to save the Planets info in the local DB
     - Parameter planets: An array of PlanetInfo objects to be saved in the local DB
     */
    func save(planets: [PlanetInfo]?) {

        guard let planetsInfo = planets else {
            NSLog("No planets data to save")
            return
        }

        _ = planetsInfo.compactMap { planetInfo in
            let planet = Planets(context: dataStoreContainer.viewContext())
            planet.name = planetInfo.name
            planet.rotationPeriod = planetInfo.rotationPeriod
            planet.orbitalPeriod = planetInfo.orbitalPeriod
            planet.diameter = planetInfo.diameter
            planet.climate = planetInfo.climate
            planet.gravity = planetInfo.gravity
            planet.terrain = planetInfo.terrain
            planet.surfaceWater = planetInfo.surfaceWater
            planet.population = planetInfo.population
            planet.residents = planetInfo.residents
            planet.films = planetInfo.films
            planet.created = planetInfo.created
            planet.edited = planetInfo.edited
            planet.url = planetInfo.url
        }

        dataStoreContainer.saveContext()
    }

    /**
     Func that fetches the Planet Info from the local DB based on the available attributes
     - Parameters:
        - sortField: A String indicating the attribute based on which the result should be sorted
        - filter: A predicate based on which the result should be filtered. Can be nil.
     - Returns: An array of PlanetInfo read from the local DB matching the sort and filter conditions
     */
    func readPlanetInfo(sortField: String, filter: NSPredicate?) -> [PlanetInfo]? {

        let planetInfoRequest = Planets.planetsFetchRequest()
        do {
            let sort = NSSortDescriptor(key: sortField, ascending: true, selector: #selector(NSString.localizedStandardCompare(_:)))
            planetInfoRequest.sortDescriptors = [sort]
            planetInfoRequest.predicate = filter
            let planetInfo = try dataStoreContainer.viewContext().fetch(planetInfoRequest)
            return planetInfo.compactMap {
                PlanetInfo(name: $0.name,
                           rotationPeriod: $0.rotationPeriod,
                           orbitalPeriod: $0.orbitalPeriod,
                           diameter: $0.diameter,
                           climate: $0.climate,
                           gravity: $0.gravity,
                           terrain: $0.terrain,
                           surfaceWater: $0.surfaceWater,
                           population: $0.population,
                           residents: $0.residents,
                           films: $0.films,
                           created: $0.created,
                           edited: $0.edited,
                           url: $0.url ?? "Empty URL")
            }
        } catch {
            NSLog("Unable to fetch the planet info from the local DB.")
        }

        return nil
    }

    /**
     Func to save the People info in the local DB
     - Parameter personInfo: An array of PeopleInfo objects to be saved in the local DB
     */
    func save(personInfo: PeopleInfo?) {

        guard let personDetails = personInfo else {
            NSLog("No person data to save")
            return
        }

        let person = Person(context: dataStoreContainer.viewContext())
        person.name = personDetails.name
        person.height = personDetails.height
        person.mass = personDetails.mass
        person.hairColor = personDetails.hairColor
        person.skinColor = personDetails.skinColor
        person.eyeColor = personDetails.eyeColor
        person.birthYear = personDetails.birthYear
        person.gender = personDetails.gender
        person.homeworld = personDetails.homeworld
        person.films = personDetails.films
        person.species = personDetails.species
        person.vehicles = personDetails.vehicles
        person.starships = personDetails.starships
        person.created = personDetails.created
        person.edited = personDetails.edited
        person.url = personDetails.url

        dataStoreContainer.saveContext()
    }

    /**
     Func that fetches the Person Info from the local DB based for the url
     - Parameter url: Url of the Person Info to be read
     - Returns: The PeopleInfo object of the Person
     */
    func readPersonInfo(with url: String) -> PeopleInfo? {

        let personInfoRequest = Person.personfetchRequest()
        personInfoRequest.predicate = NSPredicate(format: "url == %@", url)
        
        do {
            let personInfoResponse = try dataStoreContainer.viewContext().fetch(personInfoRequest)
            guard personInfoResponse.isEmpty == false else {
                return nil
            }

            let personInfo = personInfoResponse[0]
            return PeopleInfo(name: personInfo.name,
                              height: personInfo.height,
                              mass: personInfo.mass,
                              hairColor: personInfo.hairColor,
                              skinColor: personInfo.skinColor,
                              eyeColor: personInfo.eyeColor,
                              birthYear: personInfo.birthYear,
                              gender: personInfo.gender,
                              homeworld: personInfo.homeworld,
                              films: personInfo.films,
                              species: personInfo.species,
                              vehicles: personInfo.vehicles,
                              starships: personInfo.starships,
                              created: personInfo.created,
                              edited: personInfo.edited,
                              url: personInfo.url ?? "Empty URL")
        } catch {
            NSLog("Unable to fetch the person info from the local DB.")
        }

        return nil
    }

    /**
     Func to save the Film info in the local DB
     - Parameter filmInfo: An array of FilmInfo objects to be saved in the local DB
     */
    func save(filmInfo: FilmInfo?) {

        guard let filmDetails = filmInfo else {
            NSLog("No person data to save")
            return
        }

        let film = Films(context: dataStoreContainer.viewContext())
        film.title = filmDetails.title
        film.episodeId = filmDetails.episodeId ?? 0
        film.openingCrawl = filmDetails.openingCrawl
        film.director = filmDetails.director
        film.producer = filmDetails.producer
        film.releaseDate = filmDetails.releaseDate
        film.characters = filmDetails.characters
        film.planets = filmDetails.planets
        film.starships = filmDetails.starships
        film.vehicles = filmDetails.vehicles
        film.species = filmDetails.species
        film.created = filmDetails.created
        film.edited = filmDetails.edited
        film.url = filmDetails.url

        dataStoreContainer.saveContext()
    }

    /**
     Func that fetches the Film Info from the local DB based for the url
     - Parameter url: Url of the Film Info to be read
     - Returns: The FilmInfo object of the Film
     */
    func readFilmInfo(with url: String) -> FilmInfo? {

        let filmInfoRequest = Films.filmFetchRequest()
        filmInfoRequest.predicate = NSPredicate(format: "url == %@", url)

        do {
            let filmInfoResponse = try dataStoreContainer.viewContext().fetch(filmInfoRequest)
            guard filmInfoResponse.isEmpty == false else {
                return nil
            }

            let filmInfo = filmInfoResponse[0]
            return FilmInfo(title: filmInfo.title,
                            episodeId: filmInfo.episodeId,
                            openingCrawl: filmInfo.openingCrawl,
                            director: filmInfo.director,
                            producer: filmInfo.producer,
                            releaseDate: filmInfo.releaseDate,
                            characters: filmInfo.characters,
                            planets: filmInfo.planets,
                            starships: filmInfo.starships,
                            vehicles: filmInfo.vehicles,
                            species: filmInfo.species,
                            created: filmInfo.created,
                            edited: filmInfo.edited,
                            url: filmInfo.url ?? "Empty URL")
        } catch {
            NSLog("Unable to fetch the film info from the local DB.")
        }

        return nil
    }
}
