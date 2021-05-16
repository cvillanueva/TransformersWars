//
//  AppConstants.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import Foundation
import UIKit

class AppConstants {

    // MARK: - Networking
    struct Networking {
        static let apiToken = "apiToken"
    }

    /// Defined errors requesting the API and handling the data
    enum ApiRequestError: String {
        case networkIsNotReachable = "Network is not reachable. Showing cached data."
        case serverError = "There was a server error. Showing cached data."
        case parsingError = "There was an error parsing the data received. Showing cached data."
    }

    // MARK: - UI
    // (For bigger projects I prefer to use localized strings, Swiftgen)
    struct TransformersListViewController {
        static let title = "Transformers Wars!"
        static let backButtonTitle = "Back to list"
        static let autobotCellName = "AutobotTableViewCell"
        static let decepticonCellName = "DecepticonTableViewCell"
        static let transformerCellHeight: CGFloat = 109
    }

    struct Fonts {
        static let optimus = "Optimus"
        static let optimusBold = "Optimus-Bold"
        static let optimusHollow = "OptimusHollow"
    }

    static let empty = ""
}
