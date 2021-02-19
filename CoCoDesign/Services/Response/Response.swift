//
//  Response.swift
//  GulliverAuto
//
//  Created by Phuong Vo on 11/6/19.
//  Copyright © 2019 Phuong Vo. All rights reserved.
//

import Foundation

class APIResponseError: Codable {
    let errorCode: Int?
    let message: String?
}

class Entries<T: Codable>: Codable {
    let data: T?
}

class APIResponse<T: Codable>: Codable {
    let entries: Entries<T>?
    let errors: APIResponseError?

    init(status: Bool?, entries: Entries<T>?, errors: APIResponseError?) {
        self.entries = entries
        self.errors = errors
    }
}
