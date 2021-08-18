//
//  ThemeHandler.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

var ThemeNotificationName : Notification.Name = Notification.Name("ThemeNotificationName")

struct ThemeInfo {
    
    enum Theme: Int, CaseIterable {
        case one = 1
        case two
        case three
        case four
        case other
        
        var color: UIColor? {
            switch self {
            case .one:
                return UIColor(hexString: "#13B58C")
            case .two:
                return UIColor(hexString: "#3084F2")
            case .three:
                return UIColor(hexString: "#F25757")
            case .four:
                return UIColor(hexString: "#073023")
            case .other:
                return UIColor(hexString: ThemeInfo.shared.customColorHex)
            }
        }
        
        var topGradientColor: UIColor {
            switch self {
            case .one:
                return UIColor(hexString: "#2BDBC0") ?? .clear
            case .two:
                return self.color ?? .clear
            case .three:
                return self.color ?? .clear
            case .four:
                return self.color ?? .clear
            case .other:
                return self.color ?? .clear
            }
        }
        
        var bottomGradientColor: UIColor {
            return self.color ?? .clear
        }
        
        var hexString: String {
            switch self {
            case .one: return "#13B58C"
            case .two: return "#3084F2"
            case .three: return "#F25757"
            case .four: return "#073023"
            case .other: return ThemeInfo.shared.customColorHex
            }
        }
        
        static var `default`: Theme {
            return .one
        }
    }
    
    static var shared = ThemeInfo()
    
    
    static func flush() {
        UserDefaults.standard.removeObject(forKey: "app_theme")
        UserDefaults.standard.removeObject(forKey: "app_theme_custom_color_hex")
    }
        
    static func set(_ theme: Theme, customColorHex: String?) {
        self.shared.theme = theme
        self.shared.customColorHex = customColorHex ?? ""
        NotificationCenter.default.post(name: ThemeNotificationName, object: nil)
    }
    
    private(set) var theme: Theme {
        get {
            return Theme(rawValue: UserDefaults.standard.integer(forKey: "app_theme")) ?? Theme.default
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "app_theme")
        }
    }
    
    private(set) var customColorHex: String {
        get {
            return UserDefaults.standard.string(forKey: "app_theme_custom_color_hex") ?? Theme.default.hexString
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "app_theme_custom_color_hex")
        }
    }
    
    var themeColor: UIColor? {
        return self.theme.color
    }
}

extension UIViewController {
    
    @objc func setTheme() {
        if self.isViewLoaded {
            self.view.tintColor = ThemeInfo.shared.themeColor
        }
    }
    
    func addThemeObserver() {
        if let themeProtocol = self as? ThemeProtocol, themeProtocol.shouldNotifyThemeChange {
            NotificationCenter.default.addObserver(self, selector: #selector(self.setTheme), name: ThemeNotificationName, object: nil)
        }
    }
    
    func removeThemeObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIColor {
    static var appBackground : UIColor? = UIColor(hexString: "#F6F9FF")
    
    static var appLabelBlack: UIColor? = UIColor(hexString: "#4A4A4A")
}

protocol ThemeProtocol {
    var shouldNotifyThemeChange : Bool { get }
}

extension UILabel {
    static func `default`() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.appLabelBlack
        label.textAlignment = label.appropriateLeftAlignment
        return label
    }
}


extension UITextField {
    static func `default`() -> UITextField {
        let textField = UITextField()
        textField.textColor = UIColor.appLabelBlack
        textField.textAlignment = textField.appropriateLeftAlignment
        return textField
    }
}


extension UITextView {
    static func `default`() -> UITextView {
        let textView = UITextView()
        textView.textColor = UIColor.appLabelBlack
        textView.textAlignment = textView.appropriateLeftAlignment
        return textView
    }
}
