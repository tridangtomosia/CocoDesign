//
//  APIRequestCategories.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import Combine
import SwiftUI

struct CategoriesBuilder: RequestBuilder {
    var urlRequest: URLRequest {
        return createURLRequest(url: APIURLRequest.phone.url, method: .post, parameters: [:])
    }
}

protocol APIRequestCategoriesService {
    var apiSession: APIService { get }
    func getCategories() -> AnyPublisher<APIResponse<[Categorie]>, APIError>
}

extension APIRequestCategoriesService {
    func getCategories() -> AnyPublisher<APIResponse<[Categorie]>, APIError> {
        apiSession.request(with: CategoriesBuilder(), decoder: nil)
    }
}
