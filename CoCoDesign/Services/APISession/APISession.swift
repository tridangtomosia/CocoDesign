//
//  APISession.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Combine
import Foundation

let apiMessageCommonError = "Could not process normally.\nPlease try again later."
let apiCommonError = APIError.unknown(apiMessageCommonError)

extension APIService {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    func logging(request: URLRequest) {
        DispatchQueue.main.async {
            print("\n---------------REQUEST---------------")
            print("✎ REQUEST URL: \(request.url?.absoluteString ?? "")")
            print("✎ Method: \(request.httpMethod ?? "")")
            print("✎ Header: \(String(describing: request.headers))")
            print("✎ Parameter: \(String(describing: request.parameters))")
            print("-------------------------------------\n")
        }
    }

    func logging(response: HTTPURLResponse?, request: URLRequest, data: Data, error: Error? = nil) {
        DispatchQueue.main.async {
            print("---------------RESPONSE--------------")
            let status = response?.status == .success
            print(status ? "😍 SUCCESS" : "😭 ERROR")
            print("✎ RESPONSE URL: \(String(describing: request.url?.absoluteString ?? ""))")
            if let response = response {
                print("✎ Status code: \(response.statusCode)")
                print("✎ Header: \(response.headers)")
                print("✎ Response data:")
//                print(data.prettyPrintedJSONString ?? "")
                if !status {
                    print("✎ Error: \(error?.localizedDescription ?? "")")
                } else {
                    print("✎ Body:")
                }
            } else {
                print("✎ Error: \(error?.localizedDescription ?? "")")
            }
            print("------------------------------------")
        }
    }
}

struct APISession: APIService {
    func request<T>(with builder: RequestBuilder, decoder: JSONDecoder? = nil) -> AnyPublisher<T, APIError> where T: Codable {
        logging(request: builder.urlRequest)
        let decoder = decoder ?? self.decoder
        return URLSession.shared
            .dataTaskPublisher(for: builder.urlRequest)
            .mapError { error in .unknown(error.localizedDescription) }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let response = response as? HTTPURLResponse {
                    if response.status == .success {
                        logging(response: response, request: builder.urlRequest, data: data)
                        return Just(data)
                            .decode(type: T.self, decoder: decoder).print()
                            .mapError { _ in .decodingError }
                            .eraseToAnyPublisher()
                    } else if let statusCode = HTTPStatusCode(rawValue: response.statusCode) {
                        let error = APIError.httpError(statusCode.rawValue, statusCode.description)
                        logging(response: response, request: builder.urlRequest, data: data, error: error)
                        return Fail(error: error).eraseToAnyPublisher()
                    } else {
                        logging(response: response, request: builder.urlRequest, data: data, error: apiCommonError)
                    }
                } else {
                    logging(response: nil, request: builder.urlRequest, data: data, error: apiCommonError)
                }
                return Fail(error: apiCommonError).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func upload<T>(data: Data, with builder: RequestBuilder, decoder: JSONDecoder?) -> AnyPublisher<T, APIError> where T: Codable {
        logging(request: builder.urlRequest)
        let decoder = decoder ?? self.decoder
        return URLSession.shared
            .uploadTaskPublisher(for: builder.urlRequest, data: data)
            .mapError { error in .unknown(error.localizedDescription) }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let response = response as? HTTPURLResponse {
                    if response.status == .success {
                        logging(response: response, request: builder.urlRequest, data: data)
                        return Just(data)
                            .decode(type: T.self, decoder: decoder).print()
                            .mapError { _ in .decodingError }
                            .eraseToAnyPublisher()
                    } else if let statusCode = HTTPStatusCode(rawValue: response.statusCode) {
                        let error = APIError.httpError(statusCode.rawValue, statusCode.description)
                        logging(response: response, request: builder.urlRequest, data: data, error: error)
                        return Fail(error: error).eraseToAnyPublisher()
                    } else {
                        logging(response: response, request: builder.urlRequest, data: data, error: apiCommonError)
                    }
                } else {
                    logging(response: nil, request: builder.urlRequest, data: data, error: apiCommonError)
                }
                return Fail(error: apiCommonError).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func upload<T>(url: URL, with builder: RequestBuilder, decoder: JSONDecoder?) -> AnyPublisher<T, APIError> where T: Codable {
        logging(request: builder.urlRequest)
        let decoder = decoder ?? self.decoder
        return URLSession.shared
            .uploadTaskPublisher(for: builder.urlRequest, url: url)
            .mapError { error in .unknown(error.localizedDescription) }
            .flatMap { data, response -> AnyPublisher<T, APIError> in
                if let response = response as? HTTPURLResponse {
                    logging(response: response, request: builder.urlRequest, data: data)
                    if response.status == .success {
                        return Just(data)
                            .decode(type: T.self, decoder: decoder).print()
                            .mapError { _ in .decodingError }
                            .eraseToAnyPublisher()
                    } else if let statusCode = HTTPStatusCode(rawValue: response.statusCode) {
                        let error = APIError.httpError(statusCode.rawValue, statusCode.description)
                        logging(response: response, request: builder.urlRequest, data: data, error: error)
                        return Fail(error: error).eraseToAnyPublisher()
                    } else {
                        logging(response: response, request: builder.urlRequest, data: data, error: apiCommonError)
                    }
                } else {
                    logging(response: nil, request: builder.urlRequest, data: data, error: apiCommonError)
                }
                return Fail(error: APIError.unknown(apiMessageCommonError)).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
