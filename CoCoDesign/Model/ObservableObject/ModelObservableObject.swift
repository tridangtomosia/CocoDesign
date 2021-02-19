//
//  Model.swift
//  CoCoDesign
//
//  Created by apple on 2/4/21.
//

import Combine
import SwiftUI

class PolicyModel: ObservableObject {
    @Published var isShowPolicy: Bool = false
    @Published var links: URL?
}

class EnviCovi: ObservableObject {
    @Published var score = 10
}

class CodeInputObserver: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    var codeInput = ""
    var saveArrayInput:[String] = ["","","","","",""]
    var arrayCodeInput = ["","","","","",""] {
        willSet {
            objectWillChange.send()
            if arrayCodeInput.filter({ (element) -> Bool in
                return element.count >= 1
            }).count >= 6 {
                saveArrayInput = arrayCodeInput
            }
        }
        
        didSet {
            if saveArrayInput.count == 6 && saveArrayInput.filter({ (element) -> Bool in
                return element.count >= 1
            }).count >= 6 {
                for i in 0..<arrayCodeInput.count {
                    if arrayCodeInput[i].count > 1 {
                        arrayCodeInput[i].removeLast()
                    }
                }
                return
            }
            
            codeInput = ""
            var index = ""
            for i in 0..<arrayCodeInput.count {
                if saveArrayInput[i].count > arrayCodeInput[i].count {
                    return
                }
                if saveArrayInput[i].count < arrayCodeInput[i].count && arrayCodeInput[i].count > 1 {
                    index = String(arrayCodeInput[i].last ?? "0")
                    codeInput.append(arrayCodeInput[i].first ?? "0")
                } else {
                    codeInput.append(arrayCodeInput[i])
                }
            }
            codeInput.append(index)
            
            let arrayCharacters = Array(codeInput)
            
            for i in 0..<arrayCodeInput.count {
                if i < arrayCharacters.count {
                    arrayCodeInput[i] = String(arrayCharacters[i])
                } else {
                    arrayCodeInput[i] = ""
                }
            }
        }
    }
}

class PhoneInputObserver: ObservableObject {
    var objectWillChange = ObservableObjectPublisher()
    var stateCount = 0
    var isReadyToPush = false

    var phoneNumber = "" {
        willSet {
            objectWillChange.send()
        }

        didSet {
            if phoneNumber.count >= 11 {
                isReadyToPush = true
            } else {
                isReadyToPush = false
            }
            
            if phoneNumber.count > 11 {
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
            
            if phoneNumber.count == 7{
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
