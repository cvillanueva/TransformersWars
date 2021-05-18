//
//  RequestApiToken.swift
//  TransformersWars
//
//  Created by Claudio Emilio Villanueva Albornoz on 16-05-21.
//

import Alamofire
import Foundation

// swiftlint:disable weak_delegate

/// Protocol to handle response
protocol RequestApiTokenProtocol {
    func receivedToken(token: String)
    func serverErrorHappened(errorType: AppConstants.ApiRequestError)
}

/// Call implelemtation to request the API token
class RequestApiToken {
    var delegate: RequestApiTokenProtocol?

    init(delegate: RequestApiTokenProtocol) {
        self.delegate = delegate
        request()
    }

    private func request() {
        var urlRequest = URLRequest(
            url: URL(string: AppConstants.Networking.tokenURL)!
        )

        urlRequest.method = .get
        urlRequest.timeoutInterval = 15

        if NetworkReachabilityManager()!.isReachable {
            AF.request(urlRequest).response { response in
                if let error = response.error {
                    print("[RequestApiToken] request() error:\(error)")
                    if let delegate = self.delegate {
                        delegate.serverErrorHappened(errorType: .apiTokenServerError)
                    }
                } else {
                    if let delegate = self.delegate {
                        let token = String(decoding: response.data ?? Data(), as: UTF8.self)
                        print("[RequestApiToken] request() token:\(token)")
                        delegate.receivedToken(token: token)
                    }
                }
            }
        } else {
            if let delegate = self.delegate {
                delegate.serverErrorHappened(errorType: .apiTokenNetworkIsNotReachable)
            }
        }
    }
}
