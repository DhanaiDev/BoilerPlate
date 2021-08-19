//
//  ParentTableViewController.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

class ParentTableViewController: UITableViewController {
    
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
        self.view.backgroundColor = .appBackground
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil).settingCustomFont().settingCustomFont()
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = true
        self.addThemeObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setTheme()
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setTheme()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setTheme()
        super.viewDidDisappear(animated)
    }
    
    deinit {
        self.removeThemeObserver()
    }
}
