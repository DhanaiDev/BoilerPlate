//
//  UITableLoaderView.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 17/08/21.
//

import UIKit

class UITableLoaderView : UITableViewHeaderFooterView {
   
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(greaterThanOrEqualTo: self.contentView.topAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
        ])
    }
    func startAnimate() {
        self.activityIndicator.startAnimating()
    }
    
    func stopAnimate() {
        self.activityIndicator.stopAnimating()
    }
}
