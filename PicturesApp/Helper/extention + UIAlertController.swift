//
//  extention + UIAlertController.swift
//  PicturesApp
//
//  Created by Антон Кочетков on 21.03.2022.
//

import UIKit

extension UIViewController {
    public func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let alertOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(alertOk)
        
        present(alert, animated: true, completion: nil)
    }
}
