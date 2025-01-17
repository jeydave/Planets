//
//  PlanetInfoTableCellViewModel.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import Foundation

class PlanetInfoTableCellViewModel {

    var dataStore = DataStore()

    /**
     Reads the residents list from the Url list and frames the text to be displayed in the TableView Cell
     - Parameter urls: The Url list of the Residents for whom the text should be displayed. Can be nil.
     - Returns: A String containing the framed text to be displayed under Residents
     */
    func residentsText(with urls: [String]?) -> String {

        guard let residentUrlList = urls, residentUrlList.isEmpty == false else {
            return "Residents: None"
        }

        let residents = residentUrlList.compactMap { dataStore.readPersonInfo(with: $0)?.name }.joined(separator: ", ")
        
        return residents.isEmpty ? "Residents: None" : ("Residents: " + residents)
    }

    /**
     Reads the films list from the Url list and frames the text to be displayed in the TableView Cell
     - Parameter urls: The Url list of the Films for which the text should be displayed. Can be nil.
     - Returns: A String containing the framed text to be displayed under Films
     */
    func filmsText(with urls: [String]?) -> String {

        guard let filmsUrlList = urls, filmsUrlList.isEmpty == false else {
            return "Films: None"
        }

        let films = filmsUrlList.compactMap { dataStore.readFilmInfo(with: $0)?.title }.joined(separator: ", ")
        return films.isEmpty ? "Films: None" : ("Films: " + films)
    }
}
