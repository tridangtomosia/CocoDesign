/**
 * Copyright (C) 2019 APIManager All Rights Reserved.
 */

import Alamofire
import Firebase
import Foundation
import Reachability

typealias JSObject = [String: Any]
typealias JSArray = [JSObject]
typealias JSONCompletion = (_ result: APIResult<JSObject>) -> Void
typealias ServiceCompletion = (_ result: APIResult<Codable>) -> Void
typealias Header = HTTPHeaders
typealias Parameter = Parameters
typealias ProgressHandler = Request.ProgressHandler
typealias TotalDownload = (UInt64) -> Void

enum ResponseStyle {
    case success
    case error
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

let serialQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
}()

let backgroundQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 6
    return queue
}()

let backgroundGraphQueue = DispatchQueue.global(qos: DispatchQoS.default.qosClass)

let api = APIManager()

let reachability: Reachability? = try? Reachability()

class APIManager {
    private let manager = AF

    private let lock = NSLock()
    private var _taskCount = 0
    var log = true

    let validation: DataRequest.Validation = { (_, _, _) -> Request.ValidationResult in
        Request.ValidationResult.success(())
    }

    let downloadValidation: DownloadRequest.Validation = { (_, _, _)
        -> DownloadRequest.ValidationResult in
        DownloadRequest.ValidationResult.success(())
    }

    let uploadValidation: UploadRequest.Validation = { (_, _, _)
        -> UploadRequest.ValidationResult in
        UploadRequest.ValidationResult.success(())
    }

    var taskCount: Int {
        get {
            return _taskCount
        }

        set {
            lock.sync {
                let oldValue = self.taskCount
                _taskCount = newValue
                if oldValue == 0 || newValue == 0 {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = newValue > 0
                }
            }
        }
    }

    init() {
    }

    func logout() {
        manager.session.cancelAllTasks(completion: nil)
        backgroundQueue.cancelAllOperations()
    }

    func reset() {
        manager.session.cancelAllTasks(completion: nil)
        backgroundQueue.cancelAllOperations()
    }

    @discardableResult
    func request<T: APIInputProtocol>(input: T, completion: @escaping JSONCompletion) -> DataRequest {
        let encode: ParameterEncoding = input.method == .get ? URLEncoding.queryString : JSONEncoding.default
        taskCount += 1
        let request = manager.request(input.url,
                                      method: input.method,
                                      parameters: input.parameter,
                                      encoding: encode,
                                      headers: input.header)
        request.validate(validation)
        request.response(completion: completion)
        logRequest(input: input)
        return request
    }

    func upload<T: APIInputProtocol>(data: Data,
                                     input: T,
                                     totalDownload: TotalDownload? = nil,
                                     progress: @escaping ProgressHandler,
                                     completion: @escaping JSONCompletion) {
        logRequest(input: input)

        manager.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data,
                                     withName: "image",
                                     fileName: "image.jpg",
                                     mimeType: "image/jpg")

            if let parameter = input.parameter {
                for (key, value) in parameter {
                    if let value = value as? String,
                       let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }
            totalDownload?(multipartFormData.contentLength)
        }, to: input.url,
        method: input.method,
        headers: input.header)
            .uploadProgress(closure: progress)
            .responseJSON(completionHandler: { data in
                let result = data.result
                let response = data.response ?? HTTPURLResponse()
                let metric = data.metrics
                DataRequest.saveCookies(response: response)
                let timing = metric?.taskInterval.duration ?? 0
                switch result {
                case let .success(object):
                    switch response.statusCode {
                    case 200 ... 299:
                        api.logResponse(stype: .success,
                                        response: response,
                                        value: object,
                                        error: nil,
                                        timimg: timing)

                        if let data = object as? JSObject {
                            OperationQueue.main.addOperation {
                                completion(APIResult.success(data))
                            }
                        } else {
                            OperationQueue.main.addOperation {
                                completion(APIResult.failure(APIError.json))
                            }
                        }
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
                    api.logResponse(stype: .error,
                                    response: response,
                                    value: nil,
                                    error: APIError.custom(error.description, nil),
                                    timimg: timing)
                    OperationQueue.main.addOperation {
                        completion(APIResult.failure(APIError.custom(error.description, nil)))
                    }
                }

            })
    }

    func logRequest<T: APIInputProtocol>(input: T) {
        #if DEV || STG
            if log {
                print("\n---------------REQUEST---------------")
                print("✎ REQUEST URL: \(input.url)")
                print("✎ Method: \(input.method)")
                print("✎ Header: \(String(describing: input.header))")
                print("✎ Parameter: \(String(describing: input.parameter))")
                print("-------------------------------------\n")
            }
        #endif
    }

    func logResponse(stype: ResponseStyle, response: HTTPURLResponse?, value: Any?, error: APIError?, timimg: TimeInterval) {
        #if DEV || STG
            if log {
                print("---------------RESPONSE--------------")
                let time = String(format: "%0.2fs", timimg)
                print(stype == .success ? "😍 SUCCESS (\(time))" : "😭 ERROR (\(time))")
                if let response = response {
                    print("✎ RESPONSE URL: \(String(describing: response.url))")
                    print("✎ Status code: \(response.statusCode)")
                    print("✎ Header: \(response.allHeaderFields)")
                }
                if stype == .success {
                    print("✎ Body: \(String(describing: value))")
                } else {
                    print("✎ Error: \(error?.description ?? "")")
                }
                print("------------------------------------")
            }
        #endif
    }
}

// MARK: - URLSession

extension URLSession {
    func cancelAllTasks(completion: (() -> Void)?) {
        getTasksWithCompletionHandler { tasks, uploads, downloads in
            for task in tasks {
                task.cancel()
            }
            for task in uploads {
                task.cancel()
            }
            for task in downloads {
                task.cancel()
            }
            completion?()
        }
    }
}

extension NSLock {
    func sync( block: () -> Void) {
        let locked = self.try()
        block()
        if locked {
            unlock()
        }
    }
}
