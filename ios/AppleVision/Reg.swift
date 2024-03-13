//
//  Reg.swift
//  CardScanner
//
//  Created by Howl on 04/06/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation

public struct Regex: ExpressibleByStringLiteral {
    private let pattern: String

    private var nsRegularExpression: NSRegularExpression? {
        return try? NSRegularExpression(pattern: pattern)
    }

    public typealias StringLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        pattern = value
    }

    public init(_ string: String) {
        pattern = string
    }

    /// Returns all substrings matching expression
    public func matches(in string: String) -> [String] {
        let ranges = nsRegularExpression?
            .matches(in: string, options: [], range: searchRange(for: string))
            .compactMap { Range($0.range, in: string) }
            ?? []

        return ranges
            .map { string[$0] }
            .map(String.init)
    }

    /// Returns whether or not string has substring matching expression
    public func hasMatch(in string: String) -> Bool {
        return firstMatch(in: string) != nil
    }

    /// Returns first string matching expression
    public func firstMatch(in string: String) -> String? {
        guard
            let match = nsRegularExpression?.firstMatch(
                in: string,
                options: [],
                range: searchRange(for: string)
            ),
            let matchRange = Range(match.range, in: string)
        else {
            return nil
        }

        return String(string[matchRange])
    }

    /// Returns new string with all matches replaced
    public func replacingOccurrences(in string: String, with replacement: String = "") -> String? {
        let range = searchRange(for: string)
        return nsRegularExpression?.stringByReplacingMatches(
            in: string,
            options: [],
            range: range,
            withTemplate: replacement
        )
    }

    /// Returns all regex captures in string
    public func captures(in string: String) -> [String] {
        guard
            let checkingResult = nsRegularExpression?
                .firstMatch(in: string, options: [], range: searchRange(for: string))
            else {
                return []
        }

        return (0..<checkingResult.numberOfRanges)
            .map { checkingResult.range(at: $0) }
            .compactMap { Range($0, in: string) }
            .map { string[$0] }
            .map (String.init)
    }

    private func searchRange(for string: String) -> NSRange {
        return NSRange(location: 0, length: string.utf16.count)
    }
}

// MARK: Operator related
infix operator =~
infix operator !~

extension Regex {
    /// Convenient operator for hasMatch
    public static func =~ (string: String, regex: Regex) -> Bool {
        return regex.hasMatch(in: string)
    }

    /// Convenient operator for hasMatch
    public static func =~ (regex: Regex, string: String) -> Bool {
        return regex.hasMatch(in: string)
    }

    /// Convenient operator for `!hasMatch`
    public static func !~ (string: String, regex: Regex) -> Bool {
        return !regex.hasMatch(in: string)
    }

    /// Convenient operator for `!hasMatch`
    public static func !~ (regex: Regex, string: String) -> Bool {
        return !regex.hasMatch(in: string)
    }
}
