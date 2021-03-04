//
//  UIViewController+Toaster.swift
//  Planets
//
//  Created by Andrew on 04/03/21.
//

import UIKit

extension UIViewController {
    
    func displayToaster(with message: String) {
        let topBarHeight = (self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        let labelRect = CGRect(x: 0, y: topBarHeight - 50, width: self.view.frame.size.width, height: 50)
        let toastLabel = UILabel(frame: labelRect)
        toastLabel.backgroundColor = .systemOrange
        toastLabel.textAlignment = .center
        toastLabel.text = message
        self.view.addSubview(toastLabel)
        toastLabel.alpha = 0.0
        UIView.animate(withDuration: 2.0) {
            toastLabel.alpha = 1.0
            toastLabel.frame.origin.y = topBarHeight
        } completion: { _ in
            UIView.animate(withDuration: 2.0, delay: 5.0, options: .curveLinear) {
                toastLabel.alpha = 0.0
                toastLabel.frame.origin.y = topBarHeight - 50
            } completion: { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
