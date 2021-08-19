//
//  ParentViewController.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

class ParentViewController: UIViewController {
    
    var instanceHolder : InstanceHolder = InstanceHolder()

    override var hidesBottomBarWhenPushed: Bool {
        get { return true }
        set { super.hidesBottomBarWhenPushed = true }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        super.loadView()
        self.setTheme()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).settingCustomFont().settingCustomFont()
        self.view.backgroundColor = .white
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = true
        self.addThemeObserver()
    }
    
    deinit {
        self.removeThemeObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureKeyboardToggle()
        self.navigationController?.setTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setTheme()
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.deConfigureKeyboardToggle()
        super.viewWillDisappear(animated)
        self.navigationController?.setTheme()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setTheme()
        super.viewDidDisappear(animated)
    }
    
    private func configureKeyboardToggle() {
        if let keyboardToggle = self as? KeyboardToggleProtocol {
            keyboardToggle.configureDefaults()
        }
    }
    
    private func deConfigureKeyboardToggle() {
        if let keyboardToggle = self as? KeyboardToggleProtocol {
            keyboardToggle.deConfigureDefaults()
        }
    }
}
