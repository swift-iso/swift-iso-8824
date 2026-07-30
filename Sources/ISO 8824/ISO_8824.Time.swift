// ===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftASN1 open source project
//
// Copyright (c) 2022 Apple Inc. and the SwiftASN1 project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftASN1 project authors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

extension ISO_8824 {
    /// Calendar value law shared by ``ISO_8824/GeneralizedTime`` and ``ISO_8824/UTCTime``.
    ///
    /// Upstream name: `TimeUtilities`. Only the value-validity half remains here; the
    /// wire halves migrated to swift-iso-8825 (see the trailing marker).
    @usableFromInline
    enum Time {}
}

extension ISO_8824.Time {
    @inlinable
    static func daysInMonth(_ month: Int, ofYear year: Int) -> Int? {
        switch month {
        case 1:
            return 31
        case 2:
            // This one has a dependency on the year!
            // A leap year occurs in any year divisible by 4, except when that year is divisible by 100,
            // unless the year is divisible by 400.
            let isLeapYear = (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0))
            return isLeapYear ? 29 : 28
        case 3:
            return 31
        case 4:
            return 30
        case 5:
            return 31
        case 6:
            return 30
        case 7:
            return 31
        case 8:
            return 31
        case 9:
            return 30
        case 10:
            return 31
        case 11:
            return 30
        case 12:
            return 31
        default:
            return nil
        }
    }
}

@available(*, unavailable)
extension ISO_8824.Time: Sendable {}

extension ArraySlice where Element == UInt8 {
    /// Appends the canonical decimal-ASCII representation of fractional seconds
    /// (no leading "0.", no trailing zeros). Value-canonicalization law for
    /// ``ISO_8824/GeneralizedTime/rawFractionalSeconds``.
    @inlinable
    package mutating func append(fractionalSeconds: Double) throws(ISO_8824.Error) {
        // Fractional seconds may not be negative and may not be 1 or more.
        guard fractionalSeconds >= 0 && fractionalSeconds < 1 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid fractional seconds: \(fractionalSeconds)"
            )
        }

        if fractionalSeconds != 0 {
            let fractionalSecondsAsString = String(fractionalSeconds)

            assert(fractionalSecondsAsString.starts(with: "0."), "Invalid fractional seconds")
            assert(fractionalSecondsAsString.last != "0", "Trailing zeros in fractional seconds")

            self.append(contentsOf: fractionalSecondsAsString.utf8.dropFirst(2))
        }
    }
}

extension Double {
    /// Computes the numerical fractional seconds from the canonical raw decimal-ASCII digits.
    @inlinable
    package init(fromRawFractionalSeconds rawFractionalSeconds: ArraySlice<UInt8>) throws(ISO_8824.Error) {
        if rawFractionalSeconds.count == 0 {
            self = 0
            return
        }

        if rawFractionalSeconds.last == UInt8(ascii: "0") {
            throw ISO_8824.Error.invalidASN1Object(reason: "Trailing zeros in raw fractional seconds")
        }

        let rawFractionalSecondsAsString = String(decoding: rawFractionalSeconds, as: UTF8.self)
        let fractionalSecondsAsString = "0.\(rawFractionalSecondsAsString)"

        guard let fractionalSeconds = Double(fractionalSecondsAsString) else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid raw fractional seconds"
            )
        }

        self = fractionalSeconds
    }
}

// -> ISO 8825: the wire halves of upstream TimeUtilities.swift moved to swift-iso-8825
// with the DER/BER conformance bodies:
//   - `TimeUtilities.generalizedTimeFromBytes(_:)` / `TimeUtilities.utcTimeFromBytes(_:)`
//     (YYYYMMDDHHMMSS[.f]Z / YYMMDDHHMMSSZ content-octet parsing, incl. the UTCTime
//     1950/2049 pivot `rawYear < 50 ? +2000 : +1900`)
//   - `ArraySlice<UInt8>._readFourDigitDecimalInteger()` / `._readTwoDigitDecimalInteger()`
//     / `._readRawFractionalSeconds()`
//   - `Array<UInt8>.append(_ generalizedTime:)` / `.append(_ utcTime:)` /
//     `._appendFourDigitDecimal(_:)` / `._appendTwoDigitDecimal(_:)`
//   - `Int.init?(fromDecimalASCII:)` (used only by the moved read helpers)
