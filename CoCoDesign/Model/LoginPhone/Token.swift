//
//  Token.swift
//  CoCoDesign
//
//  Created by apple on 2/19/21.
//

import Foundation

struct Token: Codable {
    var token: String
    var accountStatus: acountStatus
    
    enum CodingKey: String, Codable {
        case token = "token"
        case accountStatus = "account_status"
    }
}

enum acountStatus: String, Codable {
    case new = "NEW"
    case old = "OLD"
}

struct Response: Codable {
    var data: Token
}

//class APIResponse<T: Codable>: Codable {
////    let entries: Entries<T>?
//    let data: T?
//    let meta: APIResponseError?
////    let errors: APIResponseError?
//    init(status: Bool?, data: T?, meta: APIResponseError?) {
//        self.data = data
//        self.meta = meta
//    }
////    init(status: Bool?, entries: Entries<T>?, errors: APIResponseError?) {
////        self.entries = entries
////        self.errors = errors
////    }
//}
