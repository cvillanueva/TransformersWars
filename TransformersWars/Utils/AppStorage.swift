//
//  AppStorage.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 15-05-21.
//

import Foundation

class AppStorage {
    /// Stores a API token to local storage
    /// - Parameter token: API token value
    static func storeApiToken(token: String) {
        print("[AppStorage] storeToken() token:\(token)")
        let userDefaults = UserDefaults.standard
         userDefaults.set(token, forKey: AppConstants.Networking.apiToken)
    }

    /// Gets the API token from local storage
    /// - Returns: A string containing the API key
    static func getApiToken() -> String {
        return UserDefaults.standard.string(
            forKey: AppConstants.Networking.apiToken
        ) ?? AppConstants.empty
    }
}
