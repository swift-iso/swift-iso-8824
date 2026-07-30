// ===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftASN1 open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftASN1 project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftASN1 project authors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

import Testing

@testable import ISO_8824

extension ISO_8824.UTCTime {
    @Suite
    struct Test {}
}

extension ISO_8824.UTCTime.Test {
    @Test
    func `comparisons order by component significance`() throws {
        enum ExpectedComparisonResult {
            case lessThan
            case equal
            case greaterThan
        }

        let original = try ISO_8824.UTCTime(year: 2020, month: 03, day: 03, hours: 03, minutes: 03, seconds: 03)

        func modify(
            _ field: WritableKeyPath<ISO_8824.UTCTime, Int>,
            of time: ISO_8824.UTCTime,
            by modifier: Int
        ) -> ISO_8824.UTCTime {
            var copy = time
            copy[keyPath: field] += modifier
            return copy
        }

        let integerTransformable: [WritableKeyPath<ISO_8824.UTCTime, Int>] = [
            \.year, \.month, \.day, \.hours, \.minutes, \.seconds,
        ]

        var transformationsAndResults: [(ISO_8824.UTCTime, ExpectedComparisonResult)] = []
        transformationsAndResults.append((original, .equal))

        for transform in integerTransformable {
            transformationsAndResults.append((modify(transform, of: original, by: 1), .greaterThan))
            transformationsAndResults.append((modify(transform, of: original, by: -1), .lessThan))
        }

        transformationsAndResults.append(
            (
                try ISO_8824.UTCTime(year: 2019, month: 08, day: 08, hours: 08, minutes: 08, seconds: 08),
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
