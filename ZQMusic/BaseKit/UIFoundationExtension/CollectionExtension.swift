//
//  CollectionExtension.swift
//  KLChat
//
//  Created by lw on 2022/3/25.
//

import Foundation

public extension Collection {

    /// Convert self to JSON String.
    /// - Returns: Returns the JSON as String or empty string if error while parsing.
    func toJsonstring(options opt: JSONSerialization.WritingOptions = [.prettyPrinted]) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: opt)
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}

public extension Array {

    func chunked(by distance: Int) -> [[Element]] {
        precondition(distance > 0, "distance must be greater than 0") // prevents infinite loop

        if self.count <= distance {
            return [self]
        } else {
            let head = [Array(self[0 ..< distance])]
            let tail = Array(self[distance ..< self.count])
            return head + tail.chunked(by: distance)
        }
    }

}
