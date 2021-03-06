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
        static let endpoint = "http://4480e126ac0b.ngrok.io"
    #elseif STG
        static let endpoint = ""
    #else
        static let endpoint = "http://4480e126ac0b.ngrok.io"
    #endif

    enum Version: String {
        case v1

        var path: String {
            return APIPath.endpoint / "api" / rawValue
        }
    }

    struct Phone {
        static var phone: String { Version.v1.path / "phone" / "verify" }
    }

    struct Login {
        static var login: String { Version.v1.path / "login" }
    }

    struct Categories {
        static var login: String { Version.v1.path / "login" }
    }

    struct MasterCategories {
        static var MasterCategories: String { Version.v1.path / "Master-categories" }
    }

    struct Shop {
        static var shop: String { Version.v1.path / "shop" }
    }
}

enum APIURLRequest {
    case phone
    case login
    case categories
    case masterCategories
    
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
            guard let url = URL(string: APIPath.Categories.login) else {
                break
            }
            return url
        case .masterCategories:
            guard let url = URL(string: APIPath.MasterCategories.MasterCategories) else {
                break
            }
            return url
        }
        return URL(string: "")!
    }
}
