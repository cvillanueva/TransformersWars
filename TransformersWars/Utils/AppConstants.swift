//
//  AppConstants.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import Foundation
import UIKit

// swiftlint:disable line_length

class AppConstants {

    // MARK: - Networking
    struct Networking {
        static let tokenURL = "https://transformers-api.firebaseapp.com/allspark"
        static let apiURL = "https://transformers-api.firebaseapp.com/transformers"
    }

    /// Defined errors requesting the API and handling the data
    enum ApiRequestError: String {
        case apiTokenNetworkIsNotReachable = "Network is not reachable. The API token can not be retrieved. Let's retry"
        case apiTokenServerError = "There was a server error. The API token can not be retrieved. Let's retry"
        case transformersListNetworkIsNotReachable = "Network is not reachable. The list of transformers can not be retrieved. Let's retry"
        case transformersListServerError = "There was a server error. The list of transformers can not be retrieved. Let's retry"
        case transformersListParsingError = "There was a parsing error. The list of transformers can not be retrieved. Let's retry"
    }

    // MARK: - Storage
    struct StorageKey {
        static let apiToken = "apiToken"
    }

    // MARK: - UI
    // (For bigger projects I prefer to use localized strings, Swiftgen)
    struct TransformersListViewController {
        static let title = "Transformers Wars!"
        static let backButtonTitle = "Back to list"
        static let autobotCellName = "AutobotTableViewCell"
        static let decepticonCellName = "DecepticonTableViewCell"
        static let transformerCellHeight: CGFloat = 109
        static let apiTokenFailedDialogTitle = "Ooops!"
    }

    struct Fonts {
        static let optimus = "Optimus"
        static let optimusBold = "Optimus-Bold"
        static let optimusHollow = "OptimusHollow"
    }

    struct Color {
        static let redAutobot = UIColor(hex: "#fd0000")
        static let purpleDecepticon = UIColor(hex: "#443576")
    }

    static let empty = ""
    static let buttonOk = "Ok"
    static let buttonCancel = "Cancel"
}
