//
//  RequestTransformersList.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 16-05-21.
//

import Alamofire
import Foundation

// swiftlint:disable weak_delegate

/// Protocol to handle response
protocol RequestTransformersListProtocol {
    func receivedData(transformersList: [Transformer])
    func serverErrorHappened(errorType: AppConstants.ApiRequestError)
}

/// Call implelemtation to request the transformers list
class RequestTransformersList {
    var delegate: RequestTransformersListProtocol?

    init(delegate: RequestTransformersListProtocol, apiToken: String) {
        self.delegate = delegate
        request(apiToken: apiToken)
    }

    /// Performs an Alamofire request
    private func request(apiToken: String) {
        var urlRequest = URLRequest(
            url: URL(string: AppConstants.Networking.apiURL)!
        )

        urlRequest.method = .get
        urlRequest.timeoutInterval = 15
        urlRequest.headers = [.authorization(bearerToken: apiToken)]

        if NetworkReachabilityManager()!.isReachable {
            AF.request(urlRequest).responseJSON { response in
                if let error = response.error {
                    print("[RequestApiToken] request() error:\(error)")
                    if let delegate = self.delegate {
                        delegate.serverErrorHappened(errorType: .transformersListServerError)
                    }
                } else {
                    self.processResponse(response.data)
                }
            }
        } else {
            if let delegate = self.delegate {
                delegate.serverErrorHappened(errorType: .transformersListNetworkIsNotReachable)
            }
        }
    }

    /// Proccess and return the fetched data
    /// - Parameter data: Fetched data
    private func processResponse(_ data: Data?) {
        do {
            let result = try JSONDecoder().decode(
                TransformersList.self, from: data ?? Data()
            )
            if let delegate = self.delegate {
                delegate.receivedData(transformersList: result.transformers)
            }
        } catch {
            if let delegate = self.delegate {
                delegate.serverErrorHappened(errorType: .transformersListParsingError)
            }
        }
    }
}
