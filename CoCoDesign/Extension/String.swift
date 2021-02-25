/**
 * Copyright (C) 2019 Extension All Rights Reserved.
 */

import UIKit

extension String {
    var length: Int {
        return count
    }

    var isBlank: Bool {
        return trimmed.isEmpty
    }

    var isNotBlank: Bool {
        return !isBlank
    }

    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }

    subscript(i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound - r.lowerBound)
        return String(self[Range(uncheckedBounds: (start, end))])
    }

    func utf8String() -> String? {
        return addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlHostAllowed)
    }

    var intValue: Int {
        return Int(self) ?? 0
    }

    var doubleValue: Double? {
        return Double(self)
    }

    var floatValue: Float? {
        return Float(self)
    }

    var boolValue: Bool {
        return (self as NSString).boolValue
    }

    func stringByAppendingPathComponent(str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }

    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }

    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    var url: URL? {
        return URL(string: self)
    }

    var urlRequest: URLRequest? {
        return url?.request
    }

    static var randomJPGImageName: String {
        return UUID().uuidString + ".jpg"
    }

    func validate(regex: String) -> Bool {
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: self)
    }

    // Regex
    func matches(pattern: String, ignoreCase: Bool = false) -> [NSTextCheckingResult]? {
        if let regex = NSRegularExpression.regex(pattern: pattern, ignoreCase: ignoreCase) {
            let range = NSRange(location: 0, length: length)
            return regex.matches(in: self, options: [], range: range).map { $0 }
        }
        return nil
    }

    func contains(pattern: String, ignoreCase: Bool = false) -> Bool? {
        if let regex = NSRegularExpression.regex(pattern: pattern, ignoreCase: ignoreCase) {
            let range = NSRange(location: 0, length: count)
            return regex.firstMatch(in: self, options: [], range: range) != nil
        }
        return nil
    }

    func replace(pattern: String, withString replacementString: String, ignoreCase: Bool = false) -> String? {
        if let regex = NSRegularExpression.regex(pattern: pattern, ignoreCase: ignoreCase) {
            let range = NSRange(location: 0, length: count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replacementString)
        }
        return nil
    }

    func insert(index: Int, _ string: String) -> String {
        if index > length {
            return self + string
        } else if index < 0 {
            return string + self
        }
        return self[0 ..< index] + string + self[index ..< length]
    }

    static func random(length len: Int = 0, charset: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String {
        let len = len < 1 ? len : Int.random(max: 16)
        var result = String()
        let max = charset.length - 1
        for _ in 0 ..< len {
            result += String(charset[Int.random(min: 0, max: max)])
        }
        return result
    }

    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func data() -> Data? {
        return Data(base64Encoded: self)
    }

    func base64ToImage() -> UIImage? {
        if let url = URL(string: self), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return image
        }
        return nil
    }

    func toCurrency(string: String) -> String {
        guard string.count >= 4 else { return string }

        return string.reversed().enumerated()
            .reduce("") { (result, enumerate) -> String in
                let condition = enumerate.offset % 3 == 0 && enumerate.offset != 0
                return String(enumerate.element) + (condition ? "." : "") + result
            }
    }

    func removeCurrency(string: String) -> String {
        return string.replacingOccurrences(of: ".", with: "")
    }

    func foldingText() -> String {
        var tempText = ""
        tempText = folding(options: [.diacriticInsensitive, .widthInsensitive, .caseInsensitive], locale: .current)
        tempText = tempText.replacingOccurrences(of: "đ", with: "d")
        return tempText
    }

    func attributed() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }

    func add(_ string: String?) -> String {
        guard let string = string else { return self }
        return self + string
    }

    func removeSubStringFirst(_ subString: String) -> String {
        let startIndex = index(self.startIndex, offsetBy: subString.length < length ? subString.length : 0)
        return String(self[startIndex ..< endIndex])
    }

    func currency() -> String {
        guard length >= 4 else {
            return self
        }
        var i = 0
        var lastIndex = length - 1
        var number = ""
        for _ in 0 ..< length {
            let character: String = self[lastIndex]
            if i % 3 == 0 && i != 0 {
                number = number.insert(index: 0, "\(character),")
            } else {
                number = number.insert(index: 0, character)
            }
            i += 1
            lastIndex -= 1
        }
        return number
    }
}

extension String {
    func regex(pattern: String) -> Bool {
        let regexText = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regexText.evaluate(with: self)
    }

    var isEmail: Bool {
        return regex(pattern: Regex.email)
    }

    var isPhoneNumber: Bool {
        let charcter = CharacterSet(charactersIn: "+0123456789").inverted
        let inputString: NSArray = components(separatedBy: charcter) as NSArray
        let filtered = NSString(string: inputString.componentsJoined(by: ""))
        return self == filtered as String && count >= 8 && count <= 16
    }

    var isValidPassword: Bool {
        return regex(pattern: Regex.password)
    }

    var quote: String {
        return "\"\(self)\""
    }

    func removeSpecialCharacter() -> String {
        return replacingOccurrences(of: "-", with: "")
    }

    var areaPhoneCode: String {
        if let range = self.range(of: "0084"), range.lowerBound == startIndex {
            return replacingCharacters(in: range, with: "+84")
        } else if let range = self.range(of: "0"), range.lowerBound == startIndex {
            return replacingCharacters(in: range, with: "+81")
        } else {
            return ""
        }
    }

    var removeAreaPhoneCode: String {
        if let range = self.range(of: "+84"), range.lowerBound == startIndex {
            return replacingCharacters(in: range, with: "0084")
        } else if let range = self.range(of: "+81"), range.lowerBound == startIndex {
            return replacingCharacters(in: range, with: "0")
        } else {
            return self
        }
    }

    var isAiparaId: Bool {
        return regex(pattern: Regex.aiparaId)
    }

    func phoneFormat(_ filter: String = "###-####-#######") -> String {
        var onOriginal = 0
        var onFilter = 0
        var onOutput = 0
        var outputString: [Character] = [Character](repeating: Character("~"), count: filter.count)
        var done = false

        while onFilter < filter.count && !done {
            let filterChar = filter[filter.index(filter.startIndex, offsetBy: onFilter)]
            let originalChar = onOriginal >= count ? Character("~") : self[index(startIndex, offsetBy: onOriginal)]
            switch filterChar {
            case "#":
                if originalChar == Character("~") {
                    done = true
                }
                if originalChar.isNumber {
                    outputString[onOutput] = originalChar
                    onOriginal += 1
                    onFilter += 1
                    onOutput += 1
                } else {
                    onOriginal += 1
                }
            default:
                outputString[onOutput] = filterChar
                onOutput += 1
                onFilter += 1
                if originalChar == filterChar {
                    onOriginal += 1
                }
            }
        }

        var str = String(outputString).replacingOccurrences(of: "~", with: "")
        if let last = str.last, last == "-" { str.removeLast() }

        return str
    }
}

extension String {
    func transformToHTML() -> NSAttributedString {
        guard let data = self.data(using: .utf8) else { return NSAttributedString(string: self) }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString(string: self)
        }
    }

    func transformToHTMLString() -> String {
        return transformToHTML().string
    }

    func toDictionary() -> [String: String] {
        let spilits = split(separator: "&")
        return spilits.map { String($0) }.reduce([:]) { (result, string) -> [String: String] in
            var temp = result
            let keyValue = string.split(separator: "=").map { String($0) }
            if keyValue.count == 2 {
                temp[keyValue[0]] = keyValue[1]
            }
            return temp
        }
    }

    var path: String? {
        return Bundle.main.path(forResource: self, ofType: nil)
    }

    func attrsString() -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: self)
        return attributed
    }
}

extension String {
    func convertUnicode() -> String {
        let converted = unicodeScalars
            .map({ 127397 + $0.value })
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
        return converted
    }
}

extension String {
    static func getTMDBMovieImage(path: String) -> URL? {
        return URL(string: "https://image.tmdb.org/t/p/original" + path)
    }
}
