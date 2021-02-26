//
//  APIUpdateUserProfile.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import Combine
import SwiftUI

struct UserProfileBuilder: RequestBuilder {
    var userName: String
    var urlRequest: URLRequest {
        return createURLRequest(url: APIURLRequest.phone.url, method: .post, parameters: ["name": userName])
    }
}

protocol APIUpdateUserProfileService {
    var apiSession: APIService { get }
    func updateProfile(_ nameUser: String) -> AnyPublisher<APIResponse<Bool>, APIError>
}

extension APIUpdateUserProfileService {
    func updateProfile(_ nameUser: String) -> AnyPublisher<APIResponse<Bool>, APIError> {
        apiSession.request(with: PhoneLoginBuilder(phoneNumber: nameUser), decoder: nil)
    }
}
