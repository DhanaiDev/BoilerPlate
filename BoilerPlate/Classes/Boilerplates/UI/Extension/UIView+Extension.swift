//
//  UIView+Extension.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

extension UIView
{
    func fillSuperView(with inset: UIEdgeInsets = UIEdgeInsets.zero)
    {
        if let superview = self.superview
        {
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top),
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset.left),
                self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset.bottom),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset.right)
                ])
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
protocol LayoutGuide
{
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    
    var leftAnchor: NSLayoutXAxisAnchor { get }
    
    var rightAnchor: NSLayoutXAxisAnchor { get }
    
    var topAnchor: NSLayoutYAxisAnchor { get }
    
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    
    var widthAnchor: NSLayoutDimension { get }
    
    var heightAnchor: NSLayoutDimension { get }
    
    var centerXAnchor: NSLayoutXAxisAnchor { get }
    
    var centerYAnchor: NSLayoutYAxisAnchor { get }
}

extension UILayoutGuide : LayoutGuide
{
    
}

extension UIView : LayoutGuide
{
    var layoutGuide : LayoutGuide
    {
        if #available(iOS 11.0, *)
        {
            return self.safeAreaLayoutGuide
        }
        return self
    }
}


extension UIViewController
{
    var leadingAnchor : NSLayoutXAxisAnchor
    {
        return self.view.layoutGuide.leadingAnchor
    }
    
    var trailingAnchor : NSLayoutXAxisAnchor
    {
        return self.view.layoutGuide.trailingAnchor
    }
    
    var topAnchor : NSLayoutYAxisAnchor
    {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topLayoutGuide.bottomAnchor
        }
    }
    
    var bottomAnchor : NSLayoutYAxisAnchor
    {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomLayoutGuide.topAnchor
        }
    }
}
