//
//  APIRequestShop.swift
//  CoCoDesign
//
//  Created by apple on 3/1/21.
//

import Combine
import SwiftUI

struct APIRequestShopBuilder: RequestBuilder {
    var parameters: [String: Any] = [:]
    var id: Int
    
    init(id: Int, page: Int) {
        self.parameters["page"] = page
        self.id = id
    }
    var urlRequest: URLRequest {
        return createURLRequest(url: APIURLRequest.masterCategories(id).url, method: .get, parameters: parameters)
    }
}

protocol APIRequestShopService {
    var apiSession: APIService { get }
    func getListShop(_ id: Int, _ page: Int) -> AnyPublisher<APIResponse<[ShopMasterCategory]>, APIError>
}

extension APIRequestShopService {
    func getListShop(_ id: Int, _ page: Int) -> AnyPublisher<APIResponse<[ShopMasterCategory]>, APIError> {
        apiSession.request(with: APIRequestShopBuilder(id: id, page: page), decoder: nil)
    }
}
