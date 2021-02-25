//
//  NSCoder.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Foundation

extension NSCoder {
    func decodeString(forKey key: String) -> String? {
        return decodeObject(forKey: key) as? String
    }

    func decodeInt(forKey key: String) -> Int? {
        return decodeObject(forKey: key) as? Int
    }

    func decodeBoolean(forKey key: String) -> Bool? {
        return decodeObject(forKey: key) as? Bool
    }

    func decodeDate(forKey key: String) -> Date? {
        return decodeObject(forKey: key) as? Date
    }
}
