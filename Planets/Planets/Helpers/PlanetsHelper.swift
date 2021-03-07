//
//  PlanetsHelper.swift
//  Planets
//
//  Created by Andrew on 07/03/21.
//

import Foundation

class PlanetsHelper {
    
    static func peopleUrls(from planetsInfo: [PlanetInfo]) -> [String] {
        return planetsInfo.compactMap { $0.residents }.reduce([], +)
    }

    static func filmUrls(from planetsInfo: [PlanetInfo]) -> [String] {
        return planetsInfo.compactMap { $0.films }.reduce([], +)
    }
}
