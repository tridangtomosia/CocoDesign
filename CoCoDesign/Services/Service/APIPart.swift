//
//  APIPart.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Alamofire
import Foundation

precedencegroup MultiplicationPrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}

infix operator /: MultiplicationPrecedence
infix operator +: MultiplicationPrecedence

func / (left: String, right: String) -> String {
    return left + "/" + right
}

func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result = NSMutableAttributedString()
    result.append(left)
    result.append(right)
    return result
}

class APIPath {
    #if DEV
        static let endpoint = "http://coco-backend-dev.ap-northeast-1.elasticbeanstalk.com"
    #elseif STG
        static let endpoint = ""
    #else
        static let endpoint = "http://coco-backend-dev.ap-northeast-1.elasticbeanstalk.com"
    #endif

    enum Version: String {
        case v1
        case policy = "privacy-policy"

        var path: String {
            return APIPath.endpoint / "api" / rawValue
        }
        
        var link: String {
            return APIPath.endpoint / rawValue
        }
    }

    struct Phone {
        static var phone: String { Version.v1.path / "phone" / "verify" }
    }

    struct Login {
        static var login: String { Version.v1.path / "login" }
    }

    struct Categories {
        static var categories: String { Version.v1.path / "categories" }
    }

    struct MasterCategories {
        static var MasterCategories: String { Version.v1.path / "master-category"}
    }

    struct Shop {
        static var shopDetail: String { Version.v1.path / "shop" }
    }
}

enum APIURLRequest {
    case phone
    case login
    case categories
    case masterCategories(Int)
    case shopDetail(Int)
    
    var url: URL {
        switch self {
        case .phone:
            guard let url = URL(string: APIPath.Phone.phone) else {
                break
            }
            return url
            
        case .login:
            guard let url = URL(string: APIPath.Login.login) else {
                break
            }
            return url
            
        case .categories:
            guard let url = URL(string: APIPath.Categories.categories) else {
                break
            }
            return url
            
        case let .masterCategories(id):
            guard let url = URL(string: APIPath.MasterCategories.MasterCategories / "\(id)" / "shops") else {
                break
            }
            return url
        case let .shopDetail(id):
            guard let url = URL(string: APIPath.Shop.shopDetail / "\(id)") else {
                break
            }
            return url
        }
        return URL(string: "")!
    }
}
