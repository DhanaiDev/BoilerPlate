//
//  UICollectionLoaderView.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 17/08/21.
//

import UIKit

class UICollectionLoaderView : UICollectionReusableView {
   
    lazy var refreshControlIndicator: UIActivityIndicatorView = {
        let loadMoreActivityIndicator = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.gray)
        loadMoreActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadMoreActivityIndicator
    }()
    var isAnimatingFinal:Bool = false
    var currentTransform:CGAffineTransform?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.addSubview(refreshControlIndicator)
        NSLayoutConstraint.activate([
            refreshControlIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            refreshControlIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func setTransform(inTransform:CGAffineTransform, scaleFactor:CGFloat) {
        if isAnimatingFinal {
            return
        }
        self.currentTransform = inTransform
        self.refreshControlIndicator.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }
    
    //reset the animation
    func prepareInitialAnimation() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator.stopAnimating()
        self.refreshControlIndicator.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }
    
    func startAnimate() {
        self.isAnimatingFinal = true
        self.refreshControlIndicator.startAnimating()
    }
    
    func stopAnimate() {
        self.isAnimatingFinal = false
        self.refreshControlIndicator.stopAnimating()
    }
    
    //final animation to display loading
    func animateFinal() {
        if isAnimatingFinal {
            return
        }
        self.isAnimatingFinal = true
        UIView.animate(withDuration: 0.2) {
            self.refreshControlIndicator.transform = CGAffineTransform.identity
        }
    }
}

