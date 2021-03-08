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
    var banners: [Banner]?
//    var isSelected: Bool? = false
    
    var description: String {
        return """
        id: \(String(describing: id))
        name: \(String(describing: name))
        address: \(String(describing: address))
        working_time: \(String(describing: workingTime))
        description: \(String(describing: descript))
        status: \(String(describing: status))
        img_url: \(String(describing: imgUrl))
        banners: \(String(describing: banners))
        """
    }
}

struct Banner: Codable {
    var id: Int
    var order: Int
    var status: String
    var imgUrl: String
    
    var description: String {
        return """
        id: \(String(describing: id))
        order: \(String(describing: order))
        status: \(String(describing: status))
        img_url: \(String(describing: imgUrl))
        """
    }
}
