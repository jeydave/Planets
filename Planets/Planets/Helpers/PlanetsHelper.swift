//
//  PlanetsHelper.swift
//  Planets
//
//  Created by Andrew on 07/03/21.
//

import Foundation

/**
 Helper methods for the app
 */
class PlanetsHelper {
    
    /**
     Retrieve the list of Resident URLs from the PlanetInfo array
     - Parameter planetsInfo: Array of PlanetInfo objects from which the resident urls should be retrieved
     - Returns: Array of Resident URL strings
     */
    static func peopleUrls(from planetsInfo: [PlanetInfo]) -> [String] {
        return planetsInfo.compactMap { $0.residents }.reduce([], +)
    }

    /**
     Retrieve the list of Film URLs from the PlanetInfo array
     - Parameter planetsInfo: Array of PlanetInfo objects from which the film urls should be retrieved
     - Returns: Array of Film URL strings
     */
    static func filmUrls(from planetsInfo: [PlanetInfo]) -> [String] {
        return planetsInfo.compactMap { $0.films }.reduce([], +)
    }
}
