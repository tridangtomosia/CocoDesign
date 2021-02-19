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
        static let endpoint = "http://dev.aipara.tokyo"
    #elseif STG
        static let endpoint = ""
    #else
        static let endpoint = "https://www.aipara.tokyo"
    #endif

    enum Version: String {
        case v1

        var path: String {
            return APIPath.endpoint / "api" / rawValue
        }
    }

    struct NGWord {
        static var ngWords: String { Version.v1.path / "ng-words" }
    }

    struct Region {
        static var region: String { Version.v1.path / "regions" }
    }

    struct Purpose {
        static var purpose: String { Version.v1.path / "purposes" }
    }

    struct Channel {
        static var channels: String { Version.v1.path / "channels" }
        static func invite(id: String) -> String {
            channels / "invite" / id
        }

        static var effects: String { channels / "users/effect" }
        static func callHistory(channelId: String) -> String { channels / channelId / "call-history" }
        static func ownerStatus(ownerId: String) -> String { channels / "owner-status?user_id=\(ownerId)" }
        static var answerInviteGroup: String { channels / "invite/answer" }
        static var topMatchingCreateChannel: String { channels / "matching" }
    }

    struct Master {
        static var effects: String { Version.v1.path / "effects" }
    }

    struct User {
        static var users: String { Version.v1.path / "users" }
        static var auth: String { Version.v1.path / "auth" }
        static var device: String { users / "device" }
        static var friend: String { users / "friends" }

        static var login: String { auth / "login" }
        static var logout: String { users / "logout" }
        static func loginSocial(provider: AuthenticationInput.Provider) -> String {
            return auth / "socials" / provider.rawValue
        }

        static var register: String { auth / "register" }
        static var verifyCode: String { auth / "verify-code" }

        static var updateFirebaseAuth: String { users / "firebase-auth" }
        static var requestResetPassword: String { users / "password-reset" }
        static var verifyResetPassword: String { requestResetPassword / "verify-code" }
        static var category: String { Version.v1.path / "categories" }
        static var updateCategory: String { users / "categories" }
        static var profile: String { users / "profiles" }
        static var language: String { Version.v1.path / "languages" }
        static var profileImages: String { profile / "images" }
        static func deleteProfileImageById(id: String) -> String {
            return profileImages / id
        }

        static var profileUpdateImage: String { profile / "update-images" }

        static var searchAccount: String { users / "search" }
        static func sendInvite(id: String) -> String {
            users / "friends" / id / "invite"
        }

        static func deleteInvite(id: String) -> String {
            users / "friends" / id
        }

        static func checkStatusFriend(id: String) -> String {
            users / "friends" / id / "status"
        }

        static func answerInviteFriend(id: String, answer: String) -> String {
            users / "friends" / id / "answer?action=\(answer)"
        }

        static var uploadImageMessage: String { Version.v1.path / "images/messages" }
        static var uploadReceipt: String { users / "purchase/ios" }
        static var updatePointPurchases: String { users / "update-point-purchase" }
        static var acquisitions: String { users / "acquisitions" }
        static var onlineStatus: String { users / "online-status" }
        static var callHistories: String { users / "call-histories" }

        static func deleteCallHistory(id: Int) -> String { callHistories / id.toString }
        static func reportUser(id: Int) -> String { users / id.toString / "reports" }

        static var getBlockFriend: String { friend / "blocks" }
        static func blockFriend(id: Int) -> String { friend / id.toString / "block" }
        static func unblockFriend(id: Int) -> String { friend / id.toString / "unblock" }
        static func checkBlockFriend(id: Int) -> String { friend / id.toString / "is-block" }
    }

    struct Point {
        static var point: String { Version.v1.path / "point" }
        static var pointConsumption: String { point / "consumptions" }
        static var pointSetting: String { point / "setting" }
    }

    struct Purchase {
        static var purchases: String { Version.v1.path / "point-purchases" }
    }

    struct LineProfile {
        static var profile = "https://api.line.me/v2/profile"
    }
    
    struct AgoraChannelProfile {
        static func getAgoraChannelProfile(appId: String, channelName: String) -> String {
            "https://api.agora.io/dev/v1/channel/user/\(appId)/\(channelName)"
        }
    }

    struct WebView {
        static var term: String { APIPath.endpoint / "term-of-use" }
        static var privacy: String { APIPath.endpoint / "privacy-policy" }
        static var licenseAgreement: String { APIPath.endpoint / "license-agree" }
    }
    
    struct AvatarDefault {
        static var male: String { APIPath.endpoint / "images/avatar_default_male.png" }
        static var female: String { APIPath.endpoint / "images/avatar_default_female.png" }
    }
}
