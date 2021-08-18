//
//  Asset.swift
//  BoilerPlate
//
//  Created by dhanasekaran on 18/08/21.
//

import Foundation
import UIKit

enum Asset: String
{
    case icCheck = "icCheck"
    case icClose = "icClose"
}

extension Asset
{
    var image: UIImage? {
        return UIImage.init(named: self.rawValue)
    }
    var templateImage: UIImage?
    {
        return UIImage(named: self.rawValue)?.withRenderingMode(.alwaysTemplate)
    }
}
