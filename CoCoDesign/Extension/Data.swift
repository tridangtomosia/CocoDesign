//
//  Data.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Foundation

extension Data {
    func base64String() -> String {
        return "data:image/jpeg;base64," + base64EncodedString()
    }

    func toDictionary() -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
        } catch {
            return nil
        }
    }

    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
