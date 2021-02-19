//
//  Respone.swift
//  CoCoDesign
//
//  Created by apple on 2/18/21.
//

import Foundation

struct ResponseData: Codable {
    var data: [ModelResponse]
}

struct ModelResponse: Codable {
    var name: String
}
