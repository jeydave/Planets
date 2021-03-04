//
//  PlanetInfoTableViewCell.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 27/02/21.
//

import UIKit

enum LabelType: Int {
    case diameter
    case rotationalPeriod
    case orbitalPeriod
    case climate
    case terrain
    case gravity
    case population
    case surfaceWater
    case residents
    case films
}

class PlanetInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var planetName: UILabel!
    @IBOutlet var planetDetailsCollection: [UILabel]!

    lazy var viewModel: PlanetInfoTableCellViewModel = {
        return PlanetInfoTableCellViewModel()
    }()

    var planetInfo: PlanetInfo? {
        didSet {

            planetName.text = planetInfo?.name
            planetDetailsCollection[LabelType.diameter.rawValue].text = "Diameter: \(planetInfo?.diameter ?? "0") kms"
            planetDetailsCollection[LabelType.rotationalPeriod.rawValue].text = "Rotational Period: \(planetInfo?.rotationPeriod ?? "0") standard hours"
            planetDetailsCollection[LabelType.orbitalPeriod.rawValue].text = "Orbital Period: \(planetInfo?.orbitalPeriod ?? "0") standard days"
            planetDetailsCollection[LabelType.climate.rawValue].text = "Climate: \(planetInfo?.climate?.capitalized ?? "Unknown")"
            planetDetailsCollection[LabelType.terrain.rawValue].text = "Terrain: \(planetInfo?.terrain?.capitalized ?? "Unknown")"
            planetDetailsCollection[LabelType.gravity.rawValue].text = "Gravity: \(planetInfo?.gravity?.capitalized ?? "Unknown")"
            planetDetailsCollection[LabelType.population.rawValue].text = "Population: \(planetInfo?.population?.capitalized ?? "Unknown")"
            planetDetailsCollection[LabelType.surfaceWater.rawValue].text = "Surface Water: \(planetInfo?.surfaceWater ?? "Unknown")"
            planetDetailsCollection[LabelType.residents.rawValue].text = viewModel.residentsText(with: planetInfo?.residents)
            planetDetailsCollection[LabelType.films.rawValue].text = viewModel.filmsText(with: planetInfo?.films)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        planetDetailsCollection.forEach {
            $0.textColor = .darkGray
            $0.font = .systemFont(ofSize: 12.0, weight: .light)
        }
    }
}
