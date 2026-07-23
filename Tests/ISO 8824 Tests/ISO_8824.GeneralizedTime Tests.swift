//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftASN1 open source project
//
// Copyright (c) 2021 Apple Inc. and the SwiftASN1 project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftASN1 project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Testing

@testable import ISO_8824

extension ISO_8824.GeneralizedTime {
    @Suite
    struct Test {}
}

extension ISO_8824.GeneralizedTime.Test {
    @Test(
        arguments: [
            (year: -1, month: 1, day: 1, hours: 1, minutes: 1, seconds: 1),  // Invalid year, negative
            (year: 2000, month: 0, day: 1, hours: 1, minutes: 1, seconds: 1),  // Invalid month, zero
            (year: 2000, month: -1, day: 1, hours: 1, minutes: 1, seconds: 1),  // Invalid month, negative
            (year: 2000, month: 13, day: 1, hours: 1, minutes: 1, seconds: 1),  // Invalid month, too large
            (year: 2000, month: 1, day: 0, hours: 1, minutes: 1, seconds: 1),  // Invalid day, zero
            (year: 2000, month: 1, day: -1, hours: 1, minutes: 1, seconds: 1),  // Invalid day, negative
            (year: 2000, month: 1, day: 32, hours: 1, minutes: 1, seconds: 1),  // only 31 days in January
            (year: 2021, month: 2, day: 29, hours: 1, minutes: 1, seconds: 1),  // only 28 days in February 2021
            (year: 2020, month: 2, day: 30, hours: 1, minutes: 1, seconds: 1),  // only 29 days in February 2020
            (year: 2100, month: 2, day: 29, hours: 1, minutes: 1, seconds: 1),  // only 28 days in February 2100
            (year: 2000, month: 2, day: 30, hours: 1, minutes: 1, seconds: 1),  // only 29 days in February 2000
            (year: 2000, month: 3, day: 32, hours: 1, minutes: 1, seconds: 1),  // only 31 days in March
            (year: 2000, month: 4, day: 31, hours: 1, minutes: 1, seconds: 1),  // only 30 days in April
            (year: 2000, month: 5, day: 32, hours: 1, minutes: 1, seconds: 1),  // only 31 days in May
            (year: 2000, month: 6, day: 31, hours: 1, minutes: 1, seconds: 1),  // only 30 days in June
            (year: 2000, month: 7, day: 32, hours: 1, minutes: 1, seconds: 1),  // only 31 days in July
            (year: 2000, month: 8, day: 32, hours: 1, minutes: 1, seconds: 1),  // only 31 days in August
            (year: 2000, month: 9, day: 31, hours: 1, minutes: 1, seconds: 1),  // only 30 days in September
            (year: 2000, month: 10, day: 32, hours: 1, minutes: 1, seconds: 1),  // only 31 days in October
            (year: 2000, month: 11, day: 31, hours: 1, minutes: 1, seconds: 1),  // only 30 days in November
            (year: 2000, month: 11, day: 32, hours: 1, minutes: 1, seconds: 1),  // only 31 days in December (upstream vector)
            (year: 2000, month: 1, day: 1, hours: -1, minutes: 1, seconds: 1),  // Invalid hour, negative
            (year: 2000, month: 1, day: 1, hours: 24, minutes: 0, seconds: 0),  // Invalid hour, 24
            (year: 2000, month: 1, day: 1, hours: 0, minutes: -1, seconds: 1),  // Invalid minute, negative
            (year: 2000, month: 1, day: 1, hours: 0, minutes: 60, seconds: 0),  // Invalid minute, 60
            (year: 2000, month: 1, day: 1, hours: 0, minutes: 0, seconds: -1),  // Invalid second, negative
            (year: 2000, month: 1, day: 1, hours: 0, minutes: 0, seconds: 62),  // Invalid second, 62 (we allow some leap seconds)
        ]
    )
    func `out-of-bounds components rejected by both initializers`(
        year: Int,
        month: Int,
        day: Int,
        hours: Int,
        minutes: Int,
        seconds: Int
    ) {
        #expect(throws: ISO_8824.Error.self) {
            try ISO_8824.GeneralizedTime(
                year: year,
                month: month,
                day: day,
                hours: hours,
                minutes: minutes,
                seconds: seconds,
                fractionalSeconds: 0
            )
        }
        #expect(throws: ISO_8824.Error.self) {
            try ISO_8824.GeneralizedTime(
                year: year,
                month: month,
                day: day,
                hours: hours,
                minutes: minutes,
                seconds: seconds,
                rawFractionalSeconds: ArraySlice<UInt8>()
            )
        }
    }

    @Test
    func `out-of-bounds fractional seconds rejected`() {
        // Invalid fractional seconds, negative
        #expect(throws: ISO_8824.Error.self) {
            try ISO_8824.GeneralizedTime(
                year: 2000,
                month: 1,
                day: 1,
                hours: 0,
                minutes: 0,
                seconds: 0,
                fractionalSeconds: -0.5
            )
        }
        // Invalid fractional seconds, greater than one
        #expect(throws: ISO_8824.Error.self) {
            try ISO_8824.GeneralizedTime(
                year: 2000,
                month: 1,
                day: 1,
                hours: 0,
                minutes: 0,
                seconds: 0,
                fractionalSeconds: 1.1
            )
        }
    }

    @Test
    func `raw fractional seconds canonicalization`() throws {
        // `fractionalSeconds` loses precision and becomes 0.1 (as opposed to 0.10000000000000001),
        // but `rawFractionalSeconds` is preserved exactly.
        let precise = try ISO_8824.GeneralizedTime(
            year: 1985,
            month: 11,
            day: 6,
            hours: 21,
            minutes: 6,
            seconds: 27,
            rawFractionalSeconds: ArraySlice<UInt8>([
                49, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 49,
            ])
        )
        #expect(precise.fractionalSeconds == 0.1)
        #expect(precise.rawFractionalSeconds.count == 17)

        // Trailing zeros in raw fractional seconds are non-canonical and rejected.
        #expect(throws: ISO_8824.Error.self) {
            try ISO_8824.GeneralizedTime(
                year: 1992,
                month: 6,
                day: 22,
                hours: 12,
                minutes: 34,
                seconds: 21,
                rawFractionalSeconds: ArraySlice<UInt8>([51, 48])
            )
        }
    }

    @Test
    func `comparisons order by component significance`() throws {
        enum ExpectedComparisonResult {
            case lessThan
            case equal
            case greaterThan
        }

        let original = try ISO_8824.GeneralizedTime(
            year: 2020,
            month: 03,
            day: 03,
            hours: 03,
            minutes: 03,
            seconds: 03,
            fractionalSeconds: 0.105
        )

        func modify<Modifiable: AdditiveArithmetic>(
            _ field: WritableKeyPath<ISO_8824.GeneralizedTime, Modifiable>,
            of time: ISO_8824.GeneralizedTime,
            by modifier: Modifiable
        ) -> ISO_8824.GeneralizedTime {
            var copy = time
            copy[keyPath: field] += modifier
            return copy
        }

        let integerTransformable: [WritableKeyPath<ISO_8824.GeneralizedTime, Int>] = [
            \.year, \.month, \.day, \.hours, \.minutes, \.seconds,
        ]

        var transformationsAndResults: [(ISO_8824.GeneralizedTime, ExpectedComparisonResult)] = []
        transformationsAndResults.append((original, .equal))

        for transform in integerTransformable {
            transformationsAndResults.append((modify(transform, of: original, by: 1), .greaterThan))
            transformationsAndResults.append((modify(transform, of: original, by: -1), .lessThan))
        }

        transformationsAndResults.append((modify(\.fractionalSeconds, of: original, by: 0.1), .greaterThan))
        transformationsAndResults.append((modify(\.fractionalSeconds, of: original, by: -0.1), .lessThan))

        transformationsAndResults.append(
            (
                try ISO_8824.GeneralizedTime(
                    year: 2019,
                    month: 08,
                    day: 08,
                    hours: 08,
                    minutes: 08,
                    seconds: 08,
                    fractionalSeconds: 0.205
                ),
                .lessThan
            )
        )

        for (newValue, expectedResult) in transformationsAndResults {
            switch expectedResult {
            case .lessThan:
                #expect(newValue < original)
                #expect(newValue <= original)
                #expect(original > newValue)
                #expect(original >= newValue)
            case .equal:
                #expect(newValue >= original)
                #expect(original >= newValue)
                #expect(newValue <= original)
                #expect(original <= newValue)
            case .greaterThan:
                #expect(newValue > original)
                #expect(newValue >= original)
                #expect(original < newValue)
                #expect(original <= newValue)
            }
        }
    }
}

// -> ISO 8825: the wire-facing halves of upstream GeneralizedTimeTests.swift moved to
// swift-iso-8825 with the codec:
//   - testSimpleGeneralizedTimeTestVectors (DER string-vector parse + round-trip; the
//     valid/invalid YYYYMMDDHHMMSS[.f]Z vector table lives with the 8825 parse tests)
//   - testTruncatedRepresentationsRejected (truncation/junk-suffix DER parse rejection)
//   - testRequiresAppropriateTag (tag mismatch on derEncoded init)
