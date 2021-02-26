//
//  PhoneInputObserver.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Combine
import SwiftUI

class PhoneVerifyObserver: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    var stateCount = 0
    var isCompleted = false
    
    var phoneRequest: String {
        var string = phoneNumber
        var phone = ""
        if phoneNumber.count > 11 {
            string.removeFirst()
            string.forEach({
                if $0 != "-" {
                    phone.append($0)
                }
            })
        } else {
            string.forEach({
                if $0 != "-" {
                    phone.append($0)
                } else {
                    phone.append("")
                }
            })
        }
        return phone
    }
    
    var phone: String {
        var string = phoneNumber
        var phone = ""
        if phoneNumber.count > 11 {
            string.removeFirst()
            string.forEach({
                if $0 != "-" {
                    phone.append($0)
                }
            })
            let phoneNumber: NSMutableString = NSMutableString(string: phone)
            phoneNumber.insert(" ", at: 3)
            phoneNumber.insert(" ", at: 7)
            phone = phoneNumber as String
        } else {
            string.forEach({
                if $0 != "-" {
                    phone.append($0)
                } else {
                    phone.append(" ")
                }
            })
        }
        return phone
    }

    var phoneNumber = "" {
        willSet {
            objectWillChange.send()
        }

        didSet {
            if phoneNumber.count >= 11 {
                isCompleted = true
            } else {
                isCompleted = false
            }
            
            if phoneNumber.count > 12 {
                phoneNumber.removeLast()
                return
            }
            
            if phoneNumber.count == 3 {
                if phoneNumber.count < stateCount {
                    phoneNumber.removeLast()
                    stateCount = 0
                    return
                }
                phoneNumber += "-"
                stateCount = 4
            }
            
            if phoneNumber.count == 7 {
                if phoneNumber.count < stateCount {
                    phoneNumber.removeLast()
                    stateCount = 4
                    return
                }
                phoneNumber += "-"
                stateCount = 8
            }
        }
    }
}
