/**
 * Copyright (C) 2019 ResponseSerializer All Rights Reserved.
 */

import Alamofire

extension DataRequest {
    func response(completion: @escaping JSONCompletion) {
        responseJSON { (data) -> Void in
            api.taskCount -= 1
            let metric = data.metrics
            let result = data.result
            let response = data.response
            if let response = response {
                DataRequest.saveCookies(response: response)
            }

            let timing = metric?.taskInterval.duration ?? 0
            backgroundQueue.addOperation({ () -> Void in

                switch result {
                case let .success(object):
                    guard let response = response else { return }
                    switch response.statusCode {
                    case 200 ... 299:
                        if let data = object as? JSObject {
                            OperationQueue.main.addOperation {
                                completion(APIResult.success(data))
                            }
                        } else {
                            OperationQueue.main.addOperation {
                                completion(APIResult.failure(APIError.json))
                            }
                        }
                        api.logResponse(stype: .success,
                                        response: response,
                                        value: object,
                                        error: nil,
                                        timimg: timing)
                    case 401:
                        break
//                        NotificationCenter.default.post(name: .unauthentication, object: nil, userInfo: nil)
                    default:
                        var apiError = APIError.json
                        if let json = object as? JSObject,
                            let error = json["error"] as? JSObject,
                            let message = error["message"] as? String,
                            let code = error["code"] as? Int {
                            apiError = APIError.custom(message, code)
                        } else if let status = HTTPStatusCode(rawValue: response.statusCode) {
                            apiError = APIError.custom(status.description, response.statusCode)
                        }

                        OperationQueue.main.addOperation {
                            completion(APIResult.failure(apiError))
                        }
                        api.logResponse(stype: .error,
                                        response: response,
                                        value: nil,
                                        error: apiError,
                                        timimg: timing)
                    }
                case let .failure(error):
                    let apiError = APIError.custom(error.localizedDescription, nil)
                    OperationQueue.main.addOperation {
                        completion(APIResult.failure(apiError))
                    }
                    api.logResponse(stype: .error,
                                    response: response,
                                    value: nil,
                                    error: apiError,
                                    timimg: timing)
                }
            })
        }
    }

    static func saveCookies(response: HTTPURLResponse) {
        guard let headerFields = response.allHeaderFields as? [String: String] else { return }
        guard let URL = response.url else { return }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
        HTTPCookieStorage.shared.setCookies(cookies, for: URL, mainDocumentURL: nil)
    }
}
