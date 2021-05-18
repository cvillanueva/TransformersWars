//
//  RequestTransformerDelete.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 17-05-21.
//

import Alamofire
import Foundation

// swiftlint:disable weak_delegate

/// Protocol to handle response
protocol RequestTransformerDeleteProtocol {
    func serveDeletedTransformer()
    func serverErrorHappened(errorType: AppConstants.ApiRequestEditionError)
}

/// Call implelemtation to request the API token
class RequestTransformerDelete {
    var delegate: RequestTransformerDeleteProtocol?

    init(delegate: RequestTransformerDeleteProtocol, apiToken: String, model: Transformer) {
        self.delegate = delegate
        request(apiToken: apiToken, model: model)
    }

    private func request(apiToken: String, model: Transformer) {
        let url = "\(AppConstants.Networking.apiURL)/\(model.identifier)"
        print("[RequestTransformerDeleteProtocol] request() url:\(url)")
        var urlRequest = URLRequest(url: URL(string: url)!)

        urlRequest.method = .delete
        urlRequest.timeoutInterval = 15
        urlRequest.headers = [.authorization(bearerToken: apiToken)]

        if NetworkReachabilityManager()!.isReachable {
            AF.request(urlRequest).response { response in
                if let error = response.error {
                    print("[RequestTransformerDeleteProtocol] request() error:\(error)")
                    if let delegate = self.delegate {
                        delegate.serverErrorHappened(errorType: .transformerDeleteError)
                    }
                } else {
                    if let delegate = self.delegate {
                        print("[RequestTransformerDeleteProtocol] request() success")
                        delegate.serveDeletedTransformer()
                    }
                }
            }
        } else {
            if let delegate = self.delegate {
                delegate.serverErrorHappened(errorType: .transformerDeleteError)
            }
        }
    }
}
