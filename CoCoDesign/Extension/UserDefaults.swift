//
//  UserDefaults.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Foundation

extension UserDefaults {
    func getProfanityWord() -> String {
        return string(forKey: "Profanity Word") ?? ""
    }

    func setProfanityWord(word: String) {
        set(word, forKey: "Profanity Word")
        synchronize()
    }
    
    func getAgreeLicense() -> Bool {
        return bool(forKey: "License Agreement")
    }
    
    func setAgreeLicense(isAgreement: Bool) {
        setValue(isAgreement, forKey: "License Agreement")
        synchronize()
    }
}
