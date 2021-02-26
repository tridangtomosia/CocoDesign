//
//  Token.swift
//  CoCoDesign
//
//  Created by apple on 2/19/21.
//

import Foundation

struct Token: Codable, CustomStringConvertible {
    var token: String
    var accountStatus: String
    
    var description: String {
        return """
        token: \(String(describing: token))
        account_status: \(String(describing: accountStatus))
        """
    }
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
