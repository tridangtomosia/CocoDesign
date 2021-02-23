/**
 * Copyright (C) 2019 Service All Rights Reserved.
 */

import Alamofire
import Firebase
import UIKit

final class Service {
    static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601NoT)
        return decoder
    }()

    @discardableResult
    func request<T: Codable>(input: Input<T>, completion: @escaping (_ result: APIResult<T>) -> Void) -> DataRequest? {
        guard reachability?.connection != nil else {
            completion(APIResult.failure(APIError.network))
            return nil
        }

//        if let token = SettingManager.shared.account?.token {
//            input.header?["Authorization"] = "Bearer " + token
//        }
        return api.request(input: input, completion: { result in
            switch result {
            case let .success(data):
                do {
                    if let response = try? Service.decoder.decode(APIResponse<T>.self, from: data),
                       let data = response.data {
                        completion(APIResult<T>.success(data))
                    } else {
                        completion(APIResult.failure(APIError.json))
                    }
                }
            case let .failure(error):
                completion(APIResult.failure(error))
            }
        })
    }

    func requestCustom<T: Codable>(input: Input<T>, completion: @escaping (_ result: APIResult<T>) -> Void) -> DataRequest? {
        guard reachability?.connection != nil else {
            completion(APIResult.failure(APIError.network))
            return nil
        }
        return api.request(input: input, completion: { result in
            switch result {
            case let .success(data):
                do {
                    if let response = try? Service.decoder.decode(T.self, from: data) {
                        completion(APIResult<T>.success(response))
                    } else {
                        completion(APIResult.failure(APIError.json))
                    }
                }
            case let .failure(error):
                completion(APIResult.failure(error))
            }
        })
    }

    func upload<T: Codable>(data: Data, input: Input<T>, totalDownload: TotalDownload? = nil, progress: ProgressHandler? = nil, completion: @escaping (_ result: APIResult<T>) -> Void) {
        guard reachability?.connection != nil else {
            return completion(APIResult.failure(APIError.network))
        }
//        if let token = SettingManager.shared.account?.token {
//            input.header?["Authorization"] = "Bearer " + token
//        }
        let progresCompletion = progress ?? { _ in }
        api.upload(data: data,
                   input: input,
                   totalDownload: totalDownload,
                   progress: progresCompletion,
                   completion: { result in
                       switch result {
                       case let .success(data):
                           do {
                               if let response = try? Service.decoder.decode(APIResponse<T>.self, from: data),
                                   let data = response.data {
                                   completion(APIResult<T>.success(data))
                               } else {
                                   completion(APIResult.failure(APIError.json))
                               }
                           }
                       case let .failure(error):
                           completion(APIResult.failure(error))
                       }
        })
    }
}

extension JSONDecoder {
    func decode<T>(_ type: T.Type, from json: [String: Any]) throws -> T? where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: json)

        do {
            return try decode(type, from: data)
        } catch {
            print(error)
        }
        return nil
    }

    func decode<T>(_ type: T.Type, object: Any) throws -> T? where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: object)
        do {
            return try decode(type, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}

extension NSCoder {
    func decodeString(forKey key: String) -> String? {
        return decodeObject(forKey: key) as? String
    }

    func decodeInt(forKey key: String) -> Int? {
        return decodeObject(forKey: key) as? Int
    }

    func decodeBoolean(forKey key: String) -> Bool? {
        return decodeObject(forKey: key) as? Bool
    }

    func decodeDate(forKey key: String) -> Date? {
        return decodeObject(forKey: key) as? Date
    }
}
