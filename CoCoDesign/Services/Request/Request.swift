import CodableFirebase
import FirebaseFirestore
import Foundation
import UIKit

extension Encodable {
    var dictionary: [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self) else { return [:] }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] } ?? [:]
    }

    func encode() -> [String: Any] {
        let encoder = FirestoreEncoder()
        guard let data = try? encoder.encode(self) else { return [:] }
        return data
    }

}
