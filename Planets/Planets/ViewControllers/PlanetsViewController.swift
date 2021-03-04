//
//  PlanetsViewController.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 26/02/21.
//

import UIKit

class PlanetsViewController: UIViewController {

    @IBOutlet weak var planetInfoTableView: UITableView!
    @IBOutlet weak var tableBgView: UIView!
    @IBOutlet var bgLabel: UILabel!
    @IBOutlet weak var sortBarButton: UIBarButtonItem!
    @IBOutlet weak var filterBarButton: UIBarButtonItem!
    static let planetViewTableViewCellID = "planetInfoTableCellID"

    var planetInfo: [PlanetInfo]? {
        didSet {
            refreshTableView()
        }
    }

    lazy var viewModel: PlanetsViewModel = {
        return PlanetsViewModel()
    }()

    lazy var loadingHUD: LoadingHUDViewController = {
        return LoadingHUDViewController(nibName: "LoadingHUDViewController", bundle: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.prompt = "Star Wars"
        self.title = "Planets"
        setupTableView()
        initializeViewModel()
        initializeApp()
    }

    func initializeApp() {
        planetInfo = viewModel.planetDatasource()
        showHUD()
        viewModel.fetchPlanetDetails()
    }

    func initializeViewModel() {

        viewModel.hideHUD = { [weak self] in
            DispatchQueue.main.async {
                self?.hideHUD()
            }
        }

        viewModel.updateUI = { [weak self] in
            DispatchQueue.main.async {
                self?.hideHUD()
                self?.refreshUI()
            }
        }

        viewModel.displayError = { [weak self] (error: Error?) in
            DispatchQueue.main.async {
                self?.hideHUD()
                if let error = error {
                    self?.displayErrorMessage(error: error)
                }
            }
        }
    }

    private func refreshUI() {
        self.planetInfo = viewModel.planetDatasource()
    }

    private func displayErrorMessage(error: Error) {
        let errorDescription = error.localizedDescription
        NSLog("Error description - \(errorDescription)")
        self.displayToaster(with: errorDescription)
    }

    @IBAction func onSortBarButtonClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Sort", message: "Sorts the planet list in ascending order of the selected field.", preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Name", style: .default, handler: { _ in
            self.planetInfo = self.viewModel.planetDatasource(with: "name")
        }))

        alertController.addAction(UIAlertAction(title: "Created Date", style: .default, handler: { _ in
            self.planetInfo = self.viewModel.planetDatasource()
        }))

        alertController.addAction(UIAlertAction(title: "Population", style: .default, handler: { _ in
            self.planetInfo = self.viewModel.planetDatasource(with: "population")
        }))

        alertController.addAction(UIAlertAction(title: "Diameter", style: .default, handler: { _ in
            self.planetInfo = self.viewModel.planetDatasource(with: "diameter")
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))

        alertController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        alertController.popoverPresentationController?.sourceView = self.view

        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func onFilterBarButtonClicked(_ sender: Any) {
        let alertController = UIAlertController(title: "Filter", message: "Filters the planet list based on the terrain type.", preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Mountain", style: .default, handler: { _ in
            self.planetInfo = self.viewModel.planetDatasource(filter: NSPredicate(format: "terrain CONTAINS[c] 'mountain'"))
        }))

        alertController.addAction(UIAlertAction(title: "Desert", style: .default, handler: { _ in
            self.planetInfo = self.viewModel.planetDatasource(filter: NSPredicate(format: "terrain CONTAINS[c] 'desert'"))
        }))

        alertController.addAction(UIAlertAction(title: "Grasslands", style: .default, handler: { _ in
            self.planetInfo = self.viewModel.planetDatasource(filter: NSPredicate(format: "terrain CONTAINS[c] 'grasslands'"))
        }))

        alertController.addAction(UIAlertAction(title: "Forest", style: .default, handler: { _ in
            self.planetInfo = self.viewModel.planetDatasource(filter: NSPredicate(format: "terrain CONTAINS[c] 'forest'"))
        }))

        alertController.addAction(UIAlertAction(title: "Remove filter", style: .default, handler: { _ in
            self.planetInfo = self.viewModel.planetDatasource()
        }))

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))

        alertController.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        alertController.popoverPresentationController?.sourceView = self.view

        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Table View Setup Private Methods
extension PlanetsViewController {
    private func refreshTableView() {
        canDisplayBgView()
        planetInfoTableView.reloadData()
    }

    private func canDisplayBgView() {
        guard let planetDetails = planetInfo, planetDetails.isEmpty == false else {
            self.planetInfoTableView.backgroundView?.isHidden = false
            self.planetInfoTableView.backgroundColor = .clear
            self.planetInfoTableView.separatorStyle = .none
            return
        }

        self.planetInfoTableView.backgroundView?.isHidden = true
        self.planetInfoTableView.backgroundColor = .systemGroupedBackground
        self.planetInfoTableView.separatorStyle = .singleLine
    }

    private func setupTableView() {
        planetInfoTableView.backgroundColor = .systemGroupedBackground
        planetInfoTableView.dataSource = self
        planetInfoTableView.delegate = self
        setupBgView()
    }

    private func setupBgView() {
        bgLabel.font = .systemFont(ofSize: 14.0, weight: .light)
        bgLabel.text = "Sorry!!! No planets to show at this time!!!"
        planetInfoTableView.backgroundView = tableBgView
    }
}

// MARK: - Loading HUD Private Methods
extension PlanetsViewController {
    private func showHUD() {
        loadingHUD.modalPresentationStyle = .overFullScreen
        loadingHUD.modalTransitionStyle = .crossDissolve
        self.present(loadingHUD, animated: true, completion: nil)
    }

    private func hideHUD() {
        loadingHUD.dismiss(animated: true, completion: nil)
    }
}