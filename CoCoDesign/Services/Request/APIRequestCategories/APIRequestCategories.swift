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
        return createURLRequest(url: APIURLRequest.categories.url, method: .get, parameters: [:])
    }
}

protocol APIRequestCategoriesService {
    var apiSession: APIService { get }
    func getCategories() -> AnyPublisher<APIResponse<[Category]>, APIError>
}

extension APIRequestCategoriesService {
    func getCategories() -> AnyPublisher<APIResponse<[Category]>, APIError> {
        apiSession.request(with: CategoriesBuilder(), decoder: nil)
    }
}
