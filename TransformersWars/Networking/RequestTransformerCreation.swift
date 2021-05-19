//
//  RequestTransformerCreation.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 17-05-21.
//

import Alamofire
import Foundation

// swiftlint:disable weak_delegate

/// Protocol to handle response
protocol RequestTransformerCreationProtocol {
    func serverCreatedTransformer()
    func serverErrorHappened(errorType: AppConstants.ApiRequestEditionError)
}

/// Call implelemtation to request a transformer creation
class RequestTransformerCreation {
    var delegate: RequestTransformerCreationProtocol?

    init(delegate: RequestTransformerCreationProtocol, apiToken: String, model: Transformer) {
        self.delegate = delegate
        request(apiToken: apiToken, model: model)
    }

    // Build the parameters to request the API
    private func getParameters(model: Transformer) -> Parameters {
        let parameters: Parameters = [
            "name": model.name,
            "strength": model.strength,
            "intelligence": model.intelligence,
            "speed": model.speed,
            "endurance": model.endurance,
            "rank": model.rank,
            "courage": model.courage,
            "firepower": model.firepower,
            "skill": model.skill,
            "team": model.team
        ]
        return parameters
    }

    /// Performs an Alamofire request
    private func request(apiToken: String, model: Transformer) {
        let parameters = getParameters(model: model)

        if NetworkReachabilityManager()!.isReachable {
            AF.request(
                AppConstants.Networking.apiURL,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: [.authorization(bearerToken: apiToken)]
            ).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(
                            with: AFdata.data ?? Data()
                    ) as? [String: Any] else {
                        print("[RequestTransformerCreation] Error converting data to JSON object")
                        if let delegate = self.delegate {
                            delegate.serverErrorHappened(errorType: .transformerCreationError)
                        }
                        return
                    }

                    guard let prettyJsonData = try? JSONSerialization.data(
                            withJSONObject: jsonObject,
                            options: .prettyPrinted
                    ) else {
                        print("[RequestTransformerCreation] Error converting JSON object to Pretty JSON data")
                        if let delegate = self.delegate {
                            delegate.serverErrorHappened(errorType: .transformerCreationError)
                        }
                        return
                    }

                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("[RequestTransformerCreation] Error printing JSON in String")
                        if let delegate = self.delegate {
                            delegate.serverErrorHappened(errorType: .transformerCreationError)
                        }
                        return
                    }

                    print(prettyPrintedJson)
                    if let delegate = self.delegate {
                        delegate.serverCreatedTransformer()
                    }
                } catch {
                    print("[RequestTransformerCreation] Error converting JSON data to string")
                    if let delegate = self.delegate {
                        delegate.serverErrorHappened(errorType: .transformerCreationError)
                    }
                    return
                }
            }
        }
    }
}
