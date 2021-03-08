//
//  PlanetsViewController+Tableview.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import UIKit

//MARK:- UITableViewDataSource Handling
extension PlanetsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planetInfo?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlanetsViewController.planetViewTableViewCellID) as? PlanetInfoTableViewCell else {
            return PlanetInfoTableViewCell()
        }

        if let planet = planetInfo?[indexPath.row] {
            cell.planetInfo = planet
        }

        return cell
    }
}

//MARK:- UITableViewDelegate Handling
extension PlanetsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
