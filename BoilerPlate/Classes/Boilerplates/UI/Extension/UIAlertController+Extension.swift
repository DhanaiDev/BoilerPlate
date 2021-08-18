//
//  UIAlertController+Extension.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

extension UIAlertController.Style {
    static var appropriate: UIAlertController.Style {
        if iPad {
            return .alert
        }
        
        return .actionSheet
    }
}
var iPad : Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}
