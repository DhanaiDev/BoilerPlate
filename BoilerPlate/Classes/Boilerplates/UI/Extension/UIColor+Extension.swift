//
//  UIColor+Extension.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import Foundation
import UIKit

typealias ColorTuple = (red: Int,green: Int,blue: Int)

extension UIColor
{
    /**
     Initializes and returns a color object using the specified opacity and RGB component values
     - parameter r: The red value of the color object, specified as a value from 0 to 255.
     - parameter g: The green value of the color object, specified as a value from 0 to 255.
     - parameter b: The blue value of the color object, specified as a value from 0 to 255.
     - parameter a: The opacity value of the color object, specified as a value from 0.0 to 1.0.
     */
    convenience init (r:Int ,g:Int ,b: Int ,a: CGFloat = 1.0)
    {
        let red = CGFloat(r)/255
        let green = CGFloat(g)/255
        let blue = CGFloat(b)/255
        self.init(red: red, green: green, blue: blue, alpha: a)
    }
    /**
     Initializes and returns a color object using the specified opacity and Hex Value
     - parameter hexString: The hex value of the color object. The initializer would fail if value doesn't contain '#' or the hexValue doesn't contain 6 characters(excluding '#') or isn't a valid hex Value'
     - parameter alpha: The opacity value of the color object, specified as a value from 0.0 to 1.0.
     */
    convenience init? (hexString: String, alpha: CGFloat = 1.0) {
        guard hexString.contains("#"),
            hexString.count == 7,
            let color : ColorTuple = UIColor.getRedGreenBlue(hexString: hexString)else
        {
            return nil
        }
        
        self.init(r: color.red, g: color.green, b: color.blue, a: alpha)
    }
    
    func inverseColor() -> UIColor {
        var alpha: CGFloat = 1.0

        var white: CGFloat = 0.0
        if self.getWhite(&white, alpha: &alpha) {
            return UIColor(white: 1.0 - white, alpha: alpha)
        }

        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha)
        }

        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
        }

        return self
    }
}
// MARK: - Private Utilities

extension UIColor
{
    var inverted: UIColor
    {
        var alpha: CGFloat = 1.0
        
        var white: CGFloat = 0.0
        if self.getWhite(&white, alpha: &alpha) {
            return UIColor(white: 1.0 - white, alpha: alpha)
        }
        
        var hue: CGFloat = 0.0, saturation: CGFloat = 0.0, brightness: CGFloat = 0.0
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha)
        }
        
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, alpha: alpha)
        }
        
        return self
    }

    static func getRedGreenBlue(hexString: String) -> ColorTuple?
    {
        guard let value = hexValue(hexString) else
        {
            return nil
        }
        let red : Int = (value & 0xFF0000)>>16
        let green : Int = (value & 0xFF00)>>8
        let blue : Int = value & 0xFF
        return (red,green,blue)
    }
    
    private static func hexValue(_ hexString: String) -> Int?
    {
        var hexValue : UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.scanLocation = 1
        if scanner.scanHexInt32(&hexValue)
        {
            return Int(hexValue)
        }
        return nil
    }

    static func getColorWithAlphaFrom8Digit(hex: String) -> UIColor? {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    return self.init(red: r, green: g, blue: b, alpha: a)
                }
            }
        }
        
        return nil
    }
    
    func isLight(threshold: Float = 0.5) -> Bool? {
        let originalCGColor = self.cgColor

        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }

        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
}
