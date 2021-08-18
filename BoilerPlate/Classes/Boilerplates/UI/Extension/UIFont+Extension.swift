//
//  UIFont+Extension.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import UIKit

extension UIFont {
    static func customFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        guard let name = getFontName(for: weight), let customFont = UIFont(name: name, size: size) else {
            return UIFont.systemFont(ofSize: size, weight: weight)
        }
        return customFont
    }
    
    static func optionalCustomFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont? {
        guard let name = getFontName(for: weight), let customFont = UIFont(name: name, size: size) else {
            return nil
        }
        return customFont
    }
    
    private static func getFontName(for weight: UIFont.Weight) -> String? {
        switch weight {
        case .ultraLight:
            return "Futura-Thin"
        case .thin:
            return "Futura-Thin"
        case .light:
            return "Futura-Thin"
        case .regular:
            return "Futura-Medium"
        case .medium:
            return "Futura-Medium"
        case .semibold:
            return "Futura-Bold"
        case .bold:
            return "Futura-Bold"
        case .heavy:
            return "Futura-CondensedExtraBold"
        case .black:
            return "Futura-CondensedExtraBold"
        default:
            break
        }
        return nil
    }
}
