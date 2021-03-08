//
//  PhoneInputObserver.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Combine
import SwiftUI

//class PhoneVerifyObserver: ObservableObject {
//    var objectWillChange = ObservableObjectPublisher()
//    var savedCount = 0
//    var isCompleted = false
//    
//    var phoneRequest: String {
//        var string = phoneNumber
//        var phone = ""
//        if phoneNumber.count > 11 {
//            string.removeFirst()
//            string.forEach({
//                if $0 != "-" {
//                    phone.append($0)
//                }
//            })
//        } else {
//            string.forEach({
//                if $0 != "-" {
//                    phone.append($0)
//                } else {
//                    phone.append("")
//                }
//            })
//        }
//        return phone
//    }
//    
//    var phone: String {
//        var string = phoneNumber
//        var phone = ""
//        if phoneNumber.count > 11 {
//            string.removeFirst()
//            string.forEach({
//                if $0 != "-" {
//                    phone.append($0)
//                }
//            })
//            let phoneNumber: NSMutableString = NSMutableString(string: phone)
//            phoneNumber.insert(" ", at: 3)
//            phoneNumber.insert(" ", at: 7)
//            phone = phoneNumber as String
//        } else {
//            string.forEach({
//                if $0 != "-" {
//                    phone.append($0)
//                } else {
//                    phone.append(" ")
//                }
//            })
//        }
//        return phone
//    }
//
    
//}
