//
//  RTLExtension.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

extension UIView {
    
    var isRightToLeft: Bool
    {
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }
    
    var isAppearanceRightToLeft: Bool
    {
        return UIView.userInterfaceLayoutDirection(for: UIView.appearance().semanticContentAttribute) == .rightToLeft
    }
    
    var appropriateLeftAlignment : NSTextAlignment {
        if self.isRightToLeft {
            return .right
        } else {
            return .left
        }
    }
    
    var appropriateRightAlignment : NSTextAlignment {
        if self.isRightToLeft {
            return .left
        } else {
            return .right
        }
    }
    
}

extension UIScrollView {
    func setContentOffsetForUserLayoutDirection() {
        if self.isAppearanceRightToLeft && self.superview != nil {
            DispatchQueue.main.async {
                self.setContentOffset(.init(x: (self.contentSize.width + self.contentInset.right) - self.frame.size.width, y: 0), animated: false)
            }
        }
    }
}

