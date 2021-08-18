//
//  UIViewController+Extension.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

extension UIViewController {
    var isPresented: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) && self.navigationController?.viewControllers.count == 1
            || self.tabBarController?.presentingViewController is UITabBarController
    }
}
