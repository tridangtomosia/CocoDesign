//
//  APIRequestShopDetail.swift
//  CoCoDesign
//
//  Created by apple on 3/16/21.
//

import Combine
import SwiftUI

struct APIRequestShopDetailBuilder: RequestBuilder {
    var parameters: [String: Any] = [:]
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
    var urlRequest: URLRequest {
        return createURLRequest(url: APIURLRequest.shopDetail(id).url, method: .get, parameters: parameters)
    }
}

protocol APIRequestShopDetailService {
    var apiSession: APIService { get }
    func getShopDetail(_ id: Int) -> AnyPublisher<APIResponse<ShopMasterCategory>, APIError>
}

extension APIRequestShopDetailService {
    func getShopDetail(_ id: Int) -> AnyPublisher<APIResponse<ShopMasterCategory>, APIError> {
        apiSession.request(with: APIRequestShopDetailBuilder(id: id), decoder: nil)
    }
}
