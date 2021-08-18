//
//  KeyboardToggleProtocol.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

private typealias KeyboardToggleViewController = UIViewController & KeyboardToggleProtocol

protocol KeyboardToggleProtocol {
    
    var shouldRespondForKeyboardNotification : Bool { get }
    
    func configureDefaults()
    
    func deConfigureDefaults()
    
    func adjustLayoutByKeyboardState(_ showKeyboard : Bool, keyboardFrame: CGRect, duration: TimeInterval, info : [AnyHashable : Any]?)
}

@objc fileprivate extension UIViewController {
    @objc func keyboardWillShow(_ notification : NSNotification) {
        guard let keyboardToggleProtocol = self as? KeyboardToggleViewController else {
            return
        }
        keyboardToggleProtocol.toggle(true, info: notification.userInfo)
    }
    
    @objc func keyboardWillHide(_ notification : NSNotification) {
        guard let keyboardToggleProtocol = self as? KeyboardToggleViewController else {
            return
        }
        keyboardToggleProtocol.toggle(false, info: notification.userInfo)
    }
}

extension KeyboardToggleProtocol where Self : UIViewController {
    
    var shouldRespondForKeyboardNotification : Bool {
        return false
    }
    
    func configureDefaults() {
        if self.shouldRespondForKeyboardNotification {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    func deConfigureDefaults() {
        if self.shouldRespondForKeyboardNotification {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    fileprivate func toggle(_ showKeyboard : Bool, info : [AnyHashable : Any]?) {
        if let presentedViewController = self.presentedViewController, presentedViewController.isKind(of: UIAlertController.self) == false {
            if let keyboardToggleProtocol = presentedViewController as? KeyboardToggleViewController {
                keyboardToggleProtocol.toggle(showKeyboard, info: info)
            }
            
            if presentedViewController.isKind(of: UISearchController.self) == false {
                return
            }
        }
        var animationCurve : UIView.AnimationCurve = .linear

        if let userInfo = info , let animationCurveUserInfoValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] , let animationCurveUserInfoNumber = animationCurveUserInfoValue as? NSNumber , animationCurveUserInfoNumber.intValue <= UIView.AnimationCurve.linear.rawValue {
            
            animationCurve = UIView.AnimationCurve(rawValue: animationCurveUserInfoNumber.intValue)!
        }

        var animationOptions : UIView.AnimationOptions = .beginFromCurrentState
        switch animationCurve {
        case .easeIn:
            animationOptions = [.beginFromCurrentState , .curveEaseIn]
            break
        case .easeInOut:
            animationOptions = [.beginFromCurrentState , .curveEaseInOut]
            break
        case .easeOut:
            animationOptions = [.beginFromCurrentState , .curveEaseOut]
            break
        case .linear:
            animationOptions = [.beginFromCurrentState , .curveLinear]
            break
        @unknown default:
            break
        }
        var duration : Double = 0

        if let userInfo = info , let animationDurationUserInfoValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] {
            duration = (animationDurationUserInfoValue as! NSNumber).doubleValue
        }

        UIView.animate(withDuration: duration, delay: 0, options: animationOptions, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        var keyboardFrame : CGRect = CGRect.zero
        
        if let keyboardBoundsValue = info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardFrame = keyboardBoundsValue.cgRectValue
        }

        self.adjustLayoutByKeyboardState(showKeyboard, keyboardFrame: keyboardFrame, duration: duration, info: info)
    }
}
