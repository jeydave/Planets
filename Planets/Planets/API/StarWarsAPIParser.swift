//
//  StarWarsAPIParser.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import Foundation

class StarWarsAPIParser {

    static func parsePlanetListResponse(with data: Data) -> [PlanetInfo]? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let planetDetails = try jsonDecoder.decode(PlanetListResponse.self, from: data)
            guard let planetListResponse = planetDetails.results, planetListResponse.isEmpty == false else {
                return nil
            }

            let planetListInfo = planetListResponse.compactMap {
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
                           url: $0.url)
            }
            return planetListInfo

        } catch {
            NSLog("Error while trying to parse the data - \(error)")
        }

        return nil
    }

    static func parsePersonResponse(with data: Data) -> PeopleInfo? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let personDetails = try jsonDecoder.decode(PeopleResponse.self, from: data)
            let personInfo = PeopleInfo(name: personDetails.name,
                                        height: personDetails.height,
                                        mass: personDetails.mass,
                                        hairColor: personDetails.hairColor,
                                        skinColor: personDetails.skinColor,
                                        eyeColor: personDetails.eyeColor,
                                        birthYear: personDetails.birthYear,
                                        gender: personDetails.gender,
                                        homeworld: personDetails.homeworld,
                                        films: personDetails.films,
                                        species: personDetails.species,
                                        vehicles: personDetails.vehicles,
                                        starships: personDetails.starships,
                                        created: personDetails.created,
                                        edited: personDetails.edited,
                                        url: personDetails.url)

            return personInfo

        } catch {
            NSLog("Error while trying to parse the Person data - \(error)")
        }

        return nil
    }

    static func parseFilmResponse(with data: Data) -> FilmInfo? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let filmDetails = try jsonDecoder.decode(FilmResponse.self, from: data)
            let filmInfo = FilmInfo(title: filmDetails.title,
                                    episodeId: filmDetails.episodeId,
                                    openingCrawl: filmDetails.openingCrawl,
                                    director: filmDetails.director,
                                    producer: filmDetails.producer,
                                    releaseDate: filmDetails.releaseDate,
                                    characters: filmDetails.characters,
                                    planets: filmDetails.planets,
                                    starships: filmDetails.starships,
                                    vehicles: filmDetails.vehicles,
                                    species: filmDetails.species,
                                    created: filmDetails.created,
                                    edited: filmDetails.edited,
                                    url: filmDetails.url)

            return filmInfo

        } catch {
            NSLog("Error while trying to parse the Film data - \(error)")
        }

        return nil
    }
}
