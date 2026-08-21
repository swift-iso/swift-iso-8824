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

        let original = try ISO_8824.UTCTime(
            year: 2020,
            month: 03,
            day: 03,
            hours: 03,
            minutes: 03,
            seconds: 03
        )

        func modify(
            of time: ISO_8824.UTCTime,
            year: Int = 0,
            month: Int = 0,
            day: Int = 0,
            hours: Int = 0,
            minutes: Int = 0,
            seconds: Int = 0
        ) throws -> ISO_8824.UTCTime {
            try ISO_8824.UTCTime(
                year: time.year + year,
                month: time.month + month,
                day: time.day + day,
                hours: time.hours + hours,
                minutes: time.minutes + minutes,
                seconds: time.seconds + seconds
            )
        }

        let integerTransformable: [(ISO_8824.UTCTime, Int) throws -> ISO_8824.UTCTime] = [
            { try modify(of: $0, year: $1) },
            { try modify(of: $0, month: $1) },
            { try modify(of: $0, day: $1) },
            { try modify(of: $0, hours: $1) },
            { try modify(of: $0, minutes: $1) },
            { try modify(of: $0, seconds: $1) },
        ]

        var transformationsAndResults: [(ISO_8824.UTCTime, ExpectedComparisonResult)] = []
        transformationsAndResults.append((original, .equal))

        for transform in integerTransformable {
            transformationsAndResults.append((try transform(original, 1), .greaterThan))
            transformationsAndResults.append((try transform(original, -1), .lessThan))
        }

        transformationsAndResults.append(
            (
                try ISO_8824.UTCTime(
                    year: 2019,
                    month: 08,
                    day: 08,
                    hours: 08,
                    minutes: 08,
                    seconds: 08
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
