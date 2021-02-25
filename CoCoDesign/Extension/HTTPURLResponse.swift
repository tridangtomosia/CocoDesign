//
//  HTTPURLResponse.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Foundation

extension HTTPURLResponse {
    enum Status {
        case success
        case failed
    }

    var status: Status {
        if (200 ... 299).contains(statusCode) {
            return .success
        } else {
            return .failed
        }
    }
}
