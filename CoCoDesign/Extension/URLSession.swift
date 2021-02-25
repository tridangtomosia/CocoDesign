//
//  URLSession.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Combine
import Foundation

extension URLSession {
    func uploadTaskPublisher(for request: URLRequest, data: Data) -> UploadTaskPublisher {
        return UploadTaskPublisher(session: self, request: request, sourceData: data)
    }

    func uploadTaskPublisher(for request: URLRequest, url: URL) -> UploadTaskPublisher {
        return UploadTaskPublisher(session: self, request: request, sourceURL: url)
    }

    func downloadTaskPublisher(for url: URL) -> URLSession.DownloadTaskPublisher {
        downloadTaskPublisher(for: .init(url: url))
    }

    func downloadTaskPublisher(for request: URLRequest) -> URLSession.DownloadTaskPublisher {
        return DownloadTaskPublisher(request: request, session: self)
    }

    // MARK: - Upload task
    struct UploadTaskPublisher: Publisher {
        typealias Output = (data: Data, response: URLResponse)
        typealias Failure = URLError

        private weak var session: URLSession!
        private var request: URLRequest!
        private var sourceData: Data?
        private var sourceURL: URL?

        init(session: URLSession? = nil, request: URLRequest? = nil, sourceData: Data? = nil, sourceURL: URL? = nil) {
            self.session = session
            self.request = request
            self.sourceData = sourceData
            self.sourceURL = sourceURL
        }

        func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = UploadTaskSubscription(subscriber: subscriber, session: session, request: request, sourceData: sourceData, sourceURL: sourceURL)
            subscriber.receive(subscription: subscription)
        }
    }

    class UploadTaskSubscription<SubscriberType: Subscriber>: Subscription where
        SubscriberType.Input == (data: Data, response: URLResponse), SubscriberType.Failure == URLError {
        var combineIdentifier = CombineIdentifier()

        private var subscriber: SubscriberType?
        private weak var session: URLSession!
        private var request: URLRequest!
        private var task: URLSessionUploadTask!
        private var sourceData: Data?
        private var sourceURL: URL?

        init(subscriber: SubscriberType? = nil, session: URLSession? = nil, request: URLRequest? = nil, sourceData: Data?, sourceURL: URL?) {
            self.subscriber = subscriber
            self.session = session
            self.request = request
            self.sourceData = sourceData
            self.sourceURL = sourceURL
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > 0 else {
                return
            }
            if let sourceData = sourceData {
                task = session.uploadTask(with: request, from: sourceData, completionHandler: { [weak self] data, response, error in
                    guard let self = self else { return }
                    self.handleUploadTaskCompletion(data: data, response: response, error: error)
                })
            } else if let url = sourceURL {
                task = session.uploadTask(with: request, fromFile: url, completionHandler: { [weak self] data, response, error in
                    guard let self = self else { return }
                    self.handleUploadTaskCompletion(data: data, response: response, error: error)
                })
            }
            task?.resume()
        }

        func cancel() {
            task.cancel()
        }

        // MARK: - Private methods
        private func handleUploadTaskCompletion(data: Data?, response: URLResponse?, error: Error?) {
            if let error = error as? URLError {
                subscriber?.receive(completion: .failure(error))
                return
            }
            guard let response = response, let data = data else {
                subscriber?.receive(completion: .failure(URLError(.badServerResponse)))
                return
            }
            _ = subscriber?.receive((data: data, response: response))
            subscriber?.receive(completion: .finished)
        }
    }

    // MARK: - Download task
    struct DownloadTaskPublisher: Publisher {
        typealias Output = (url: URL, response: URLResponse)
        typealias Failure = URLError

        let request: URLRequest
        let session: URLSession

        init(request: URLRequest, session: URLSession) {
            self.request = request
            self.session = session
        }

        func receive<S>(subscriber: S) where S: Subscriber, DownloadTaskPublisher.Failure == S.Failure, DownloadTaskPublisher.Output == S.Input {
            let subscription = DownloadTaskSubscription(subscriber: subscriber, session: session, request: request)
            subscriber.receive(subscription: subscription)
        }
    }

    class DownloadTaskSubscription<SubscriberType: Subscriber>: Subscription where
        SubscriberType.Input == (url: URL, response: URLResponse), SubscriberType.Failure == URLError {
        private var subscriber: SubscriberType?
        private weak var session: URLSession!
        private var request: URLRequest!
        private var task: URLSessionDownloadTask!

        init(subscriber: SubscriberType, session: URLSession, request: URLRequest) {
            self.subscriber = subscriber
            self.session = session
            self.request = request
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > 0 else {
                return
            }
            task = session.downloadTask(with: request) { [weak self] url, response, error in
                guard let self = self else { return }
                if let error = error as? URLError {
                    self.subscriber?.receive(completion: .failure(error))
                    return
                }
                guard let response = response else {
                    self.subscriber?.receive(completion: .failure(URLError(.badServerResponse)))
                    return
                }
                guard let url = url else {
                    self.subscriber?.receive(completion: .failure(URLError(.badURL)))
                    return
                }
                do {
                    guard let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
                    let fileUrl = cacheDir.appendingPathComponent(UUID().uuidString)
                    try FileManager.default.moveItem(atPath: url.path, toPath: fileUrl.path)
                    _ = self.subscriber?.receive((url: fileUrl, response: response))
                    self.subscriber?.receive(completion: .finished)
                } catch {
                    self.subscriber?.receive(completion: .failure(URLError(.cannotCreateFile)))
                }
            }
            task.resume()
        }

        func cancel() {
            task.cancel()
        }
    }
}
