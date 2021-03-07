//
//  MockDataStore.swift
//  PlanetsTests
//
//  Created by Andrew on 05/03/21.
//

@testable import Planets
import Foundation
import CoreData

class SingleDataMockDataStore: DataStore {
    
    override init() {
        super.init()
        deleteAllData()
        saveMockData()
    }
    
    deinit {
        deleteAllData()
    }
        
    private func saveMockData() {
        let planet1 = PlanetInfo(name: "planet1",
                                 rotationPeriod: "10",
                                 orbitalPeriod: "100",
                                 diameter: "1000",
                                 climate: "Cold",
                                 gravity: "1G",
                                 terrain: "Rocky",
                                 surfaceWater: "2",
                                 population: "10000",
                                 residents: ["PersonUrl1"],
                                 films: ["FilmUrl1"],
                                 created: "2014-12-01T13:50:49.641000Z",
                                 edited: "2014-12-01T13:50:49.641000Z",
                                 url: "url1")
        
        save(planets: [planet1])
        
        let person1 = PeopleInfo(name: "Person1", url: "PersonUrl1")
        save(personInfo: person1)
        
        let film1 = FilmInfo(title: "Film1", url: "FilmUrl1")
        save(filmInfo: film1)
    }
}

class MultiDataMockDataStore: DataStore {
    
    override init() {
        super.init()
        deleteAllData()
        saveMockData()
    }
     
    deinit {
        deleteAllData()
    }
    
    private func saveMockData() {
        let planet1 = PlanetInfo(name: "planet1",
                                 rotationPeriod: "10",
                                 orbitalPeriod: "100",
                                 diameter: "1000",
                                 climate: "Cold",
                                 gravity: "1 G",
                                 terrain: "Rocky",
                                 surfaceWater: "2",
                                 population: "200000",
                                 residents: nil,
                                 films: nil,
                                 created: "2014-12-01T13:50:49.641000Z",
                                 edited: "2014-12-01T13:50:49.641000Z",
                                 url: "url1")
        let planet2 = PlanetInfo(name: "planet2",
                                 rotationPeriod: "20",
                                 orbitalPeriod: "200",
                                 diameter: "18000",
                                 climate: "Arid",
                                 gravity: "1 G",
                                 terrain: "Desert",
                                 surfaceWater: "4",
                                 population: "100000",
                                 residents: nil,
                                 films: nil,
                                 created: "2014-12-02T13:50:49.641000Z",
                                 edited: "2014-12-02T13:50:49.641000Z",
                                 url: "url2")
        let planet3 = PlanetInfo(name: "planet3",
                                 rotationPeriod: "30",
                                 orbitalPeriod: "300",
                                 diameter: "3000",
                                 climate: "Temperate",
                                 gravity: "0 G",
                                 terrain: "Mountain",
                                 surfaceWater: "6",
                                 population: "30000",
                                 residents: nil,
                                 films: nil,
                                 created: "2014-12-12T13:50:49.641000Z",
                                 edited: "2014-12-12T13:50:49.641000Z",
                                 url: "url1")
        let planet4 = PlanetInfo(name: "planet4",
                                 rotationPeriod: "40",
                                 orbitalPeriod: "400",
                                 diameter: "4000",
                                 climate: "Cold",
                                 gravity: "2 G",
                                 terrain: "Rocky",
                                 surfaceWater: "8",
                                 population: "40000",
                                 residents: nil,
                                 films: nil,
                                 created: "2014-12-11T13:50:49.641000Z",
                                 edited: "2014-12-11T13:50:49.641000Z",
                                 url: "url4")
        let planet5 = PlanetInfo(name: "planet5",
                                 rotationPeriod: "50",
                                 orbitalPeriod: "500",
                                 diameter: "5000",
                                 climate: "Humid",
                                 gravity: "3 G",
                                 terrain: "Ocean",
                                 surfaceWater: "10",
                                 population: "50000",
                                 residents: nil,
                                 films: nil,
                                 created: "2014-12-05T13:50:49.641000Z",
                                 edited: "2014-12-05T13:50:49.641000Z",
                                 url: "url5")
        let planet6 = PlanetInfo(name: "planet6",
                                 rotationPeriod: "60",
                                 orbitalPeriod: "600",
                                 diameter: "6000",
                                 climate: "Hot",
                                 gravity: "0 G",
                                 terrain: "Grasslands",
                                 surfaceWater: "12",
                                 population: "45000",
                                 residents: nil,
                                 films: nil,
                                 created: "2014-12-08T13:50:49.641000Z",
                                 edited: "2014-12-08T13:50:49.641000Z",
                                 url: "url6")
        let planet7 = PlanetInfo(name: "planet7",
                                 rotationPeriod: "70",
                                 orbitalPeriod: "700",
                                 diameter: "7000",
                                 climate: "Cold",
                                 gravity: "0 G",
                                 terrain: "Plain",
                                 surfaceWater: "1000",
                                 population: "100000000",
                                 residents: nil,
                                 films: nil,
                                 created: "2010-10-1013:51:49.641000Z",
                                 edited: "2014-12-09T13:52:49.641000Z",
                                 url: "url7")
        let planet8 = PlanetInfo(name: "planet8",
                                 rotationPeriod: "80",
                                 orbitalPeriod: "800",
                                 diameter: "8000",
                                 climate: "Cold",
                                 gravity: "0 G",
                                 terrain: "Mountains",
                                 surfaceWater: "2",
                                 population: "35000",
                                 residents: nil,
                                 films: nil,
                                 created: "2016-12-09T13:50:49.641000Z",
                                 edited: "2016-12-09T13:50:49.641000Z",
                                 url: "url8")
        let planet9 = PlanetInfo(name: "planet9",
                                 rotationPeriod: "90",
                                 orbitalPeriod: "900",
                                 diameter: "9000",
                                 climate: "Moist",
                                 gravity: "2 G",
                                 terrain: "Rocky",
                                 surfaceWater: "18",
                                 population: "20000",
                                 residents: nil,
                                 films: ["FilmUrl1", "FilmUrl2"],
                                 created: "2014-12-10T13:50:49.641000Z",
                                 edited: "2014-12-10T13:50:49.641000Z",
                                 url: "url9")
        let planet10 = PlanetInfo(name: "planet10",
                                  rotationPeriod: "100",
                                  orbitalPeriod: "1000",
                                  diameter: "10000",
                                  climate: "Hot",
                                  gravity: "1.5 G",
                                  terrain: "Mountain",
                                  surfaceWater: "20",
                                  population: "10000",
                                  residents: ["PersonUrl1", "PersonUrl2"],
                                  films: nil,
                                  created: "2014-12-09T13:50:49.641000Z",
                                  edited: "2014-12-09T13:50:49.641000Z",
                                  url: "url10")
        
        save(planets: [planet1, planet2, planet3, planet4, planet5, planet6, planet7, planet8, planet9, planet10])
        
        let person1 = PeopleInfo(name: "Person1", url: "PersonUrl1")
        save(personInfo: person1)

        let person2 = PeopleInfo(name: "Person2", url: "PersonUrl2")
        save(personInfo: person2)

        let film1 = FilmInfo(title: "Film1", url: "FilmUrl1")
        save(filmInfo: film1)

        let film2 = FilmInfo(title: "Film2", url: "FilmUrl2")
        save(filmInfo: film2)
    }
}
