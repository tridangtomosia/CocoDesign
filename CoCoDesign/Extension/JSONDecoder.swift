//
//  JSONDecoder.swift
//  CoCoDesign
//
//  Created by apple on 2/24/21.
//

import Foundation

extension JSONDecoder {
    func decode<T>(_ type: T.Type, from json: [String: Any]) throws -> T? where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: json)

        do {
            return try decode(type, from: data)
        } catch {
            print(error)
        }
        return nil
    }

    func decode<T>(_ type: T.Type, object: Any) throws -> T? where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: object)
        do {
            return try decode(type, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}
