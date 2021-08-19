//
//  ParentNavigationController.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

class ParentNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    weak var rootViewController: UIViewController?
    
    override init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        super.init(rootViewController: rootViewController)
        self.modalPresentationStyle = .fullScreen
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.isTranslucent = false
        
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = true
        
        self.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
}

@objc protocol NavigationPreferenceProtocol {
    var prefersTransparentNavigationBar: Bool { get }
    var navigationTitleFontName: String? { get }
    var navigationTitleColor: UIColor? { get }
}

extension UIViewController : NavigationPreferenceProtocol {
    var prefersTransparentNavigationBar: Bool {
        return false
    }
    
    var navigationTitleFontName: String? {
        return nil
    }
    
    var navigationTitleColor: UIColor? {
        return nil
    }
}

