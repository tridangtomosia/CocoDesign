//
//  APIPhoneLogin.swift
//  CoCoDesign
//
//  Created by apple on 2/25/21.
//

import Combine
import SwiftUI


struct PhoneLoginBuilder: RequestBuilder {
    var phoneNumber: String
    var urlRequest: URLRequest {
        return createURLRequest(url: APIURLRequest.phone.url, method: .post, parameters: ["phone" : phoneNumber])
    }
}

protocol PhoneLoginService {
    var apiSession: APIService { get }
    func phoneInput(_ phoneNumber: String) -> AnyPublisher<APIResponse<Token>, APIError>
}

extension PhoneLoginService {
    func phoneInput(_ phoneNumber: String) -> AnyPublisher<APIResponse<Token>, APIError> {
        apiSession.request(with: PhoneLoginBuilder(phoneNumber: phoneNumber), decoder: nil)
    }
}
