//
//  UIViewController+Extensions.swift
//  FRTTestTask
//
//  Created by Vahe Hakobyan on 17.04.22.
//

import UIKit

extension UIViewController {
    
    func showOkAlert(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
