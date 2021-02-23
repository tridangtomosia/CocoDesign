/**
 * Copyright (C) 2019 Extension All Rights Reserved.
 */

import Foundation

extension Dictionary {
    mutating func append(_ dict: [Key: Value]?) {
        guard let dict = dict else { return }
        for (key, value) in dict {
            self[key] = value
        }
    }

    func queryString() -> String {
        return compactMap { "\($0)=\($1)" }.joined(separator: "&")
    }
}
