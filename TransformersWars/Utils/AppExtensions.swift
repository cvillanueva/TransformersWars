//
//  AppExtensions.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import Foundation
import UIKit

// Some extension to handle a custom font
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

extension Array {
    /// This method gets an element
    /// - Parameter index: index
    /// - Returns: out of range returns nil
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
