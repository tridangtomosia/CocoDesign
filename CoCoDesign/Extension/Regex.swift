/**
 * Copyright (C) 2019 Extension All Rights Reserved.
 */

import Foundation

struct Regex {
    #if DEV
        static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    #else
        static let email = "^(?=.{1,64}@)[A-Za-z0-9_-]+(\\.[A-Za-z0-9_-]+)*@[^-][A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z]{2,})$"
    #endif
    static let hiragana = "[ぁ-ゔゞ゛゜ー]+"
    static let katakana = "[ァ-・ヽヾ゛゜ー]+"
    static let numberic = "[0-9]+"
    static let password = "^(?=.*[A-Za-z])(?=.*[0-9])(?!.*[^A-Za-z0-9]).{8,16}$"
    static let symbol = "[:{}()\\[\\]+-.,!@#$%^&*();\\/<>$\\|\"'\\\\_£€$¥•?=~]+"
    static let organizationCode = "[\\d[A-Za-z-]]+"
    static let versionName = "[0-9]+(.[0-9])+.[0-9]"
    static let aiparaId = "^[a-zA-Z0-9]*$"
}

extension NSRegularExpression {
    class func regex(pattern: String, ignoreCase: Bool = false) -> NSRegularExpression? {
        let options: NSRegularExpression.Options = ignoreCase ? [.caseInsensitive] : []
        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {
            regex = nil
        }
        return regex
    }
}
