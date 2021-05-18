//
//  AppExtensions.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import Foundation
import UIKit

extension UIFont {
    static func optimus(size: CGFloat) -> UIFont {
        return UIFont(name: AppConstants.Fonts.optimus, size: size) ?? UIFont.systemFont(ofSize: 24)
    }

    static func optimusBold(size: CGFloat) -> UIFont {
        return UIFont(name: AppConstants.Fonts.optimusBold, size: size) ?? UIFont.systemFont(ofSize: 24)
    }

    static func optimusHollow(size: CGFloat) -> UIFont {
        return UIFont(name: AppConstants.Fonts.optimusHollow, size: size) ?? UIFont.systemFont(ofSize: 24)
    }
}
