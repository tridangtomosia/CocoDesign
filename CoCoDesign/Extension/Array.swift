/**
 * Copyright (C) 2019 Extension All Rights Reserved.
 */

import Foundation

extension Array {
    func indexOf(includeElement: (Element) -> Bool) -> Int? {
        for (index, value) in enumerated() {
            if includeElement(value) {
                return index
            }
        }
        return nil
    }

    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    func item(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }

    func items(at range: Range<Int>) -> [Element]? {
        return range.reduce([]) { (result, offset) -> [Element] in
            var temp = result
            if let item = item(at: offset) {
                temp.append(item)
            }
            return temp
        }
    }
}

extension Array where Element == String {
    func toDictionary() -> [String: Element] {
        var dictionary: [String: Element] = [:]
        for element in self {
            let components = element.components(separatedBy: "=")
            if components.count == 2 {
                dictionary[components[0]] = components[1]
            }
        }
        return dictionary
    }
}

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}
