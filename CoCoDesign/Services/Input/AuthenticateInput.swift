////
////  AuthenticateInput.swift
////  join_chat
////
////  Created by Phuong Vo on 6/30/20.
////  Copyright © 2020 Tomosia. All rights reserved.
////
//
//import Foundation
//
//struct AuthenticationInput {
//    enum Provider: String {
//        case facebook
//        case twitter
//        case line
//        case apple
//    }
//
//    final class LoginSocial: Input<Account> {
//        init(provider: Provider, name: String, firebaseAuth: String) {
//            super.init()
//            url = APIPath.User.loginSocial(provider: provider)
//            method = .post
//            parameter = ["name": name,
//                         "provider_id": firebaseAuth,
//                         "device_id": Helper.getUDID(),
//                         "device_os": "iOS",
//                         "device_name": UIDevice.current.name,
//                         "device_os_version": UIDevice.current.systemVersion,
//                         "app_version": Bundle.main.version]
//        }
//    }
//
//    final class RegisterEmail: Input<Bool> {
//        init(name: String, email: String, password: String) {
//            super.init()
//            url = APIPath.User.register
//            method = .post
//            parameter = ["name": name,
//                         "email": email,
//                         "device_id": Helper.getUDID(),
//                         "password": password,
//                         "password_confirmation": password,
//                         "device_os": "iOS",
//                         "device_name": UIDevice.current.name,
//                         "device_os_version": UIDevice.current.systemVersion,
//                         "app_version": Bundle.main.version]
//        }
//    }
//
//    final class VerifyCode: Input<Account> {
//        init(email: String, code: String) {
//            super.init()
//            url = APIPath.User.verifyCode
//            method = .post
//            parameter = ["email": email,
//                         "code": code]
//        }
//    }
//
//    final class VerifyFirebaseAuthId: Input<Account> {
//        init(code: String) {
//            super.init()
//            url = APIPath.User.updateFirebaseAuth
//            method = .post
//            parameter = ["firebase_auth": code]
//        }
//    }
//
//    final class RequestResetPassword: Input<Bool> {
//        init(email: String) {
//            super.init()
//            url = APIPath.User.requestResetPassword
//            method = .post
//            parameter = ["email": email]
//        }
//    }
//
//    final class VerifyResetPassword: Input<Bool?> {
//        init(email: String, code: String) {
//            super.init()
//            url = APIPath.User.verifyResetPassword
//            method = .post
//            parameter = ["email": email,
//                         "code": code]
//        }
//    }
//
//    final class UpdateResetPassword: Input<ResetPassword?> {
//        init(email: String, password: String, confirmPassword: String) {
//            super.init()
//            url = APIPath.User.requestResetPassword
//            method = .put
//            parameter = ["email": email,
//                         "password": password,
//                         "password_confirmation": confirmPassword]
//        }
//    }
//
//    final class LoginWithEmail: Input<Account> {
//        init(email: String, password: String, firebaseAuth: String) {
//            super.init()
//            url = APIPath.User.login
//            method = .post
//            parameter = ["email": email,
//                         "password": password,
//                         "firebase_auth": firebaseAuth,
//                         "device_id": Helper.getUDID()]
//        }
//    }
//
//    final class Logout: Input<Bool> {
//        override init() {
//            super.init()
//            url = APIPath.User.logout
//            method = .post
//            parameter = ["device_id": Helper.getUDID()]
//        }
//    }
//}
//
//struct UserInput {
//    final class GetProfile: Input<Profile> {
//        override init() {
//            super.init()
//            url = APIPath.User.profile
//            method = .get
//        }
//    }
//}
//
//struct PointUserInput {
//    final class UpdatePoint: Input<Bool> {
//        init(purchase: PointPurchase) {
//            super.init()
//            url = APIPath.User.updatePointPurchases
//            method = .post
//            parameter = purchase.dictionary
//            parameter?["device_os"] = "iOS"
//            parameter?["device_id"] = Helper.getUDID()
//        }
//    }
//}
