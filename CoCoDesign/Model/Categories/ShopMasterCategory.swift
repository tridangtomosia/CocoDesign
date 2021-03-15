//
//  ShopDetail.swift
//  CoCoDesign
//
//  Created by apple on 3/2/21.
//

import Foundation

struct ShopMasterCategory: Codable {
    var id: Int?
    var name: String?
    var address: String?
    var workingTime: String?
    var descript: String?
    var status: String?
    var imgUrl: String?
    var isSelected: Bool? = false
    var banners: [Banner]?
    
    enum CodingKey: String, Codable {
        case id, name, address, description, status, banners
        case workingTime = "working_time"
        case imgUrl = "img_url"
    }
}

struct Banner: Codable, Hashable {
    var id: Int
    var order: Int
    var status: String
    var imgUrl: String
    
    enum CodingKey: String, Codable {
        case id, order, status
        case imgUrl = "img_url"
    }
}
