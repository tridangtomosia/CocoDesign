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
        guard reachability?.isReachable() == true else {
            completion(APIResult.failure(APIError.network))
            return nil
        }

        if let token = SettingManager.shared.account?.token {
            input.header?["Authorization"] = "Bearer " + token
        }
        return api.request(input: input, completion: { result in
            switch result {
            case let .success(data):
                do {
                    if let response = try? Service.decoder.decode(APIResponse<T>.self, from: data),
                       let data = response.entries?.data {
                        completion(APIResult<T>.success(data))
                    } else {
                        completion(APIResult.failure(APIError.json))
                        ErrorCrashlytics.pushError(description: APIError.json.description,
                                                   input: input,
                                                   code: APIError.json.code)
                    }
                }
            case let .failure(error):
                completion(APIResult.failure(error))
                ErrorCrashlytics.pushError(description: error.description,
                                           input: input,
                                           code: error.code)
            }
        })
    }

    func requestCustom<T: Codable>(input: Input<T>, completion: @escaping (_ result: APIResult<T>) -> Void) -> DataRequest? {
        guard reachability?.isReachable() == true else {
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
                        ErrorCrashlytics.pushError(description: APIError.json.description,
                                                   input: input,
                                                   code: APIError.json.code)
                    }
                }
            case let .failure(error):
                completion(APIResult.failure(error))
                ErrorCrashlytics.pushError(description: error.localizedDescription,
                                           input: input,
                                           code: error.code)
            }
        })
    }

    func upload<T: Codable>(data: Data, input: Input<T>, totalDownload: TotalDownload? = nil, progress: ProgressHandler? = nil, completion: @escaping (_ result: APIResult<T>) -> Void) {
        guard reachability?.isReachable() == true else {
            return completion(APIResult.failure(APIError.network))
        }
        if let token = SettingManager.shared.account?.token {
            input.header?["Authorization"] = "Bearer " + token
        }
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
                                  let data = response.entries?.data {
                                   completion(APIResult<T>.success(data))
                               } else {
                                   completion(APIResult.failure(APIError.json))
                                   ErrorCrashlytics.pushError(description: APIError.json.description,
                                                              input: input,
                                                              code: APIError.json.code)
                               }
                           }
                       case let .failure(error):
                           completion(APIResult.failure(error))
                           ErrorCrashlytics.pushError(description: error.localizedDescription,
                                                      input: input,
                                                      code: error.code)
                       }
                   })
    }
}
