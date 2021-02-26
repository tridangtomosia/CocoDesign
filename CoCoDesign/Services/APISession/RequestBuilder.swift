//
//  HelperRequest.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Alamofire
import Combine
import Foundation

protocol RequestBuilder {
    var urlRequest: URLRequest { get }

    func createURLRequest(url: URL, method: HTTPMethod, parameters: Parameters, timeout: TimeInterval) -> URLRequest
}

extension RequestBuilder {
    func createURLRequest(url: URL, method: HTTPMethod, parameters: Parameters, timeout: TimeInterval = 40) -> URLRequest {
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.method = method
        request.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let parameterEncoding: ParameterEncoding = method == .get ? URLEncoding() : JSONEncoding()
        do {
            try request = parameterEncoding.encode(request, with: parameters)
        } catch {
            print("Encoding parameter fail: \(error.localizedDescription)")
        }
        return request
    }
}

enum APIError: Error {
    case decodingError
    case httpError(Int, String)
    case unknown(String)

    var localizedDescription: String {
        switch self {
        case .decodingError:
            return "Error format JSON"
        case let .httpError(code, message):
            return "HTTP error code: \(code). " + message
        case let .unknown(message):
            return message
        }
    }
}

protocol APIService {
    var decoder: JSONDecoder { get }

    func request<T: Codable>(with builder: RequestBuilder, decoder: JSONDecoder?) -> AnyPublisher<T, APIError>
    func upload<T: Codable>(data: Data, with builder: RequestBuilder, decoder: JSONDecoder?) -> AnyPublisher<T, APIError>
    func upload<T: Codable>(url: URL, with builder: RequestBuilder, decoder: JSONDecoder?) -> AnyPublisher<T, APIError>
}

struct APIResponseError: Codable {
    let code: Int?
    let message: String?
}

struct APIResponse<T: Codable>: Codable {
    let status: Bool?
    let data: T?
    let meta: APIResponseError?
}

enum APIResult<T> {
    case success(T)
    case failure(APIError)

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    var isFailure: Bool {
        return !isSuccess
    }

    var value: T? {
        switch self {
        case let .success(value):
            return value
        case .failure:
            return nil
        }
    }

    var error: APIError? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
}
