//
//  RequestTransformerUpdate.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 17-05-21.
//

import Alamofire
import Foundation

// swiftlint:disable weak_delegate

/// Protocol to handle response
protocol RequestTransformerUpdateProtocol {
    func serveUpdatedTransformer()
    func serverErrorHappened(errorType: AppConstants.ApiRequestEditionError)
}

/// Call implelemtation to request a transformer creation
class RequestTransformerUpdate {
    var delegate: RequestTransformerUpdateProtocol?

    init(delegate: RequestTransformerUpdateProtocol, apiToken: String, model: Transformer) {
        self.delegate = delegate
        request(apiToken: apiToken, model: model)
    }

    private func request(apiToken: String, model: Transformer) {
        let params: Parameters = [
            "id": model.identifier,
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

        print("[RequestTransformerUpdate] params:\(params)")

        if NetworkReachabilityManager()!.isReachable {
            AF.request(
                AppConstants.Networking.apiURL,
                method: .put,
                parameters: params,
                encoding: JSONEncoding.default,
                headers: [.authorization(bearerToken: apiToken)]
            ).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                        print("[RequestTransformerUpdate] Error converting data to JSON object")
                        if let delegate = self.delegate {
                            delegate.serverErrorHappened(errorType: .transformerUpdateError)
                        }
                        return
                    }

                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("[RequestTransformerUpdate] Error converting JSON object to Pretty JSON data")
                        if let delegate = self.delegate {
                            delegate.serverErrorHappened(errorType: .transformerUpdateError)
                        }
                        return
                    }

                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("[RequestTransformerUpdate] Error printing JSON in String")
                        if let delegate = self.delegate {
                            delegate.serverErrorHappened(errorType: .transformerUpdateError)
                        }
                        return
                    }

                    print(prettyPrintedJson)
                    if let delegate = self.delegate {
                        delegate.serveUpdatedTransformer()
                    }
                } catch {
                    print("[RequestTransformerUpdate] Error converting JSON data to string")
                    if let delegate = self.delegate {
                        delegate.serverErrorHappened(errorType: .transformerUpdateError)
                    }
                    return
                }
            }
        }
    }
}
