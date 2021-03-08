//
//  Categories.swift
//  CoCoDesign
//
//  Created by apple on 2/26/21.
//

import Foundation

struct Category: Codable {
    var id: Int?
    var name: String?
    var mediaId: Int?
    var order: Int?
    var status: CategoryStatus?
    var imgUrl: String?
    
    enum CodingKey: String, Codable {
        case id, name, status, order
        case mediaId = "media_id"
        case imgUrl = "img_url"
    }
//    var description: String {
//        return """
//        id: \(String(describing: id))
//        name: \(String(describing: name))
//        media_id: \(String(describing: mediaId))
//        status: \(String(describing: status))
//        img_url: \(String(describing: imgUrl))
//        order: \(String(describing: order))
//        """
//    }
}

enum CategoryStatus: String, Codable {
    case active = "ACTIVE"
    case inActive = "INACTIVE"
}
