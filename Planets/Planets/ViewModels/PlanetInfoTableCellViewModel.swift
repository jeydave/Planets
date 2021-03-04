//
//  PlanetInfoTableCellViewModel.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import Foundation

class PlanetInfoTableCellViewModel {

    func residentsText(with urls: [String]?) -> String {

        guard let residentUrlList = urls, residentUrlList.isEmpty == false else {
            return "Residents: None"
        }

        return "Residents: " + residentUrlList.compactMap { DataStore.shared.readPersonInfo(with: $0)?.name }.joined(separator: ", ")
    }

    func filmsText(with urls: [String]?) -> String {

        guard let filmsUrlList = urls, filmsUrlList.isEmpty == false else {
            return "Films: None"
        }

        return "Films: " + filmsUrlList.compactMap { DataStore.shared.readFilmInfo(with: $0)?.title }.joined(separator: ", ")
    }
}
