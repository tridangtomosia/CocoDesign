///**
// * Copyright (C) 2019 APIManager All Rights Reserved.
// */
//
//import Alamofire
//import Foundation
//
//enum SessionStoreType: CaseIterable {
//    case account
////    var path: URL? {
////        switch self {
////        case .account:
////            return FileManager.docUrl.appendingPathComponent("store.account", isDirectory: true)
////        }
////    }
//}
//
//class Session {
//    static var shared = Session()
////    var account: Account? {
////        didSet {
////            save(type: .account)
////        }
////    }
//
////    init() {
////        loadSession()
////    }
//
////    func loadSession() {
////        SessionStoreType.allCases.forEach { [weak self] type in
////            guard let self = self else { return }
////            switch type {
////            case .account:
////                self.account = loadObject(path: type.path, type: Account.self)
////            }
////        }
////    }
//
////    func save(type: SessionStoreType) {
////        switch type {
////        case .account:
////            if let account = account, let path = type.path {
////                saveObject(path: path, object: account)
////            }
////        }
////    }
//
//    func remove() {
//        SessionStoreType.allCases.forEach { type in
////            if let path = type.path {
////                if FileManager.default.fileExists(atPath: path.path) {
////                    do {
////                        try FileManager.default.removeItem(atPath: path.path)
////                    } catch {}
////                }
////            }
//        }
//    }
//
//    private func loadObject<T: Any>(path: URL?, type: T.Type) -> T? {
//        if let path = path {
//            do {
//                let data = try Data(contentsOf: path)
//                if let object = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T {
//                    return object
//                }
//            } catch {
//                return nil
//            }
//        }
//        return nil
//    }
//
//    private func saveObject<T: Any>(path: URL, object: T) {
//        do {
//            if #available(iOS 11.0, *) {
//                let data = try NSKeyedArchiver.archivedData(withRootObject: object,
//                                                            requiringSecureCoding: false)
//                try data.write(to: path)
//            } else {
//                if !NSKeyedArchiver.archiveRootObject(object, toFile: path.path) {
//                    assertionFailure("Save failed")
//                }
//            }
//        } catch {
//            assertionFailure("Save failed")
//        }
//    }
//
//    func logout() {
//        remove()
//        api.logout()
////        AppDelegate.shared.unregisterForRemoteNotifications()
//    }
//}
