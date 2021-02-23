/**
 * Copyright (C) 2019 Google All Rights Reserved.
 */

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
        static let endpoint = "http://f55eb7f2a760.ngrok.io"
    #elseif STG
        static let endpoint = ""
    #else
        static let endpoint = "http://f55eb7f2a760.ngrok.io"
    #endif

    enum Version: String {
        case v1

        var path: String {
            return APIPath.endpoint/"api" / rawValue
        }
    }
    
    struct Phone {
        static var phone: String {Version.v1.path / "phone" / "verify"}
    }
    
    struct Login {
        static var login: String {Version.v1.path / "login"}
    }
    
    struct Categories {
        static var login: String {Version.v1.path / "login"}
    }
    
    struct MasterCategories {
        static var MasterCategories: String {Version.v1.path / "Master-categories"}
    }
    
    struct Shop {
        static var shop: String {Version.v1.path / "shop"}
    }

//    struct User {
//        static var users: String { Version.v1.path / "users" }
//        static var auth: String { Version.v1.path / "auth" }
//        static var device: String { users / "device" }
//        static var friend: String { users / "friends" }
//    }
}
