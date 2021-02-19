/**
 * Copyright (C) 2019 InputProtocol All Rights Reserved.
 */

import Alamofire
import Foundation

protocol APIInputProtocol {
    associatedtype ParseType
    var url: URLConvertible { get set }
    var header: Header? { get set }
    var parameter: Parameter? { get set }
    var method: Alamofire.HTTPMethod { get set }
}

class Input<Codable>: APIInputProtocol {
    typealias ParseType = Codable
    var url: URLConvertible = ""
    var header: Header? = ["Content-Type": "application/json", "Accept": "application/json"]
    var parameter: Parameter? = [:]
    var method: Alamofire.HTTPMethod = .get
}
