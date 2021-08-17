//
//  Alert.swift
//  Dinter
//
//  Created by Luis Segoviano on 16/08/21.
//

import UIKit

class Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    
    static func showErrorRequestAlert(on vc: UIViewController, withMessage mesage: String) {
        showBasicAlert(on: vc, with: "Error al realizar la petición", message: mesage)
    }
    
    
}
