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

    enum ApiRequestEditionError: String {
        case transformerCreationError = "There was a error creating the transformer."
        case transformerUpdateError = "There was a error updating the transformer."
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

    struct TransformerEditorViewController {
        static let actionButtonTitleCreate = "Create new transformer"
        static let actionButtonTitleUpdate = "Update transformer"
    }

    struct Fonts {
        static let optimus = "Optimus"
        static let optimusBold = "Optimus-Bold"
        static let optimusHollow = "OptimusHollow"
    }

    struct Color {
        static let redAutobot = UIColor(
            red: 235.0/255.0,
            green: 0.0/255.0,
            blue: 0.0/255.0,
            alpha: 1.0
        )

        static let purpleDecepticon = UIColor(
            red: 67.0/255.0,
            green: 54.0/255.0,
            blue: 117.0/255.0,
            alpha: 1.0
        )

        static func getRandomColor() -> UIColor {
            let number = Int.random(in: 0...1)
            if number == 0 {
                return redAutobot
            } else {
                return purpleDecepticon
            }
        }
    }

    static let emptyTransformer = Transformer(
        identifier: "no_id",
        name: empty,
        strength: 1,
        intelligence: 1,
        speed: 1,
        endurance: 1,
        rank: 1,
        courage: 1,
        firepower: 1,
        skill: 1,
        team: "A",
        teamIcon: empty,
        oddCell: false
    )

    static let empty = ""
    static let buttonOk = "Ok"
    static let buttonCancel = "Cancel"
}
