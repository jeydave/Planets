//
//  LoadingHUDViewController.swift
//  Planets
//
//  Created by Andrew Davis Emerson on 02/03/21.
//

import UIKit

/**
 Displays a Loading HUD
 */
class LoadingHUDViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHUD()
    }

    private func setupHUD() {
        self.view.backgroundColor = .clear
        loadingView.layer.cornerRadius = 20.0
        loadingView.backgroundColor = .systemGray
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        loadingLabel.numberOfLines = 0
        loadingLabel.textColor = .white
        loadingLabel.font = .systemFont(ofSize: 14.0, weight: .light)
        loadingLabel.text = "Please wait while we fetch the details..."
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.stopAnimating()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
