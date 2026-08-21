import Testing

@testable import ISO_8824

extension ISO_8824.GeneralizedTime {
    @Suite
    struct Test {}
}

extension ISO_8824.GeneralizedTime.Test {
    @Test(
        arguments: [

            (year: -1, month: 1, day: 1, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 0, day: 1, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: -1, day: 1, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 13, day: 1, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 1, day: 0, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 1, day: -1, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 1, day: 32, hours: 1, minutes: 1, seconds: 1),

            (year: 2021, month: 2, day: 29, hours: 1, minutes: 1, seconds: 1),

            (year: 2020, month: 2, day: 30, hours: 1, minutes: 1, seconds: 1),

            (year: 2100, month: 2, day: 29, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 2, day: 30, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 3, day: 32, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 4, day: 31, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 5, day: 32, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 6, day: 31, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 7, day: 32, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 8, day: 32, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 9, day: 31, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 10, day: 32, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 11, day: 31, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 11, day: 32, hours: 1, minutes: 1, seconds: 1),

            (year: 2000, month: 1, day: 1, hours: -1, minutes: 1, seconds: 1),

            (year: 2000, month: 1, day: 1, hours: 24, minutes: 0, seconds: 0),

            (year: 2000, month: 1, day: 1, hours: 0, minutes: -1, seconds: 1),

            (year: 2000, month: 1, day: 1, hours: 0, minutes: 60, seconds: 0),

            (year: 2000, month: 1, day: 1, hours: 0, minutes: 0, seconds: -1),

            (year: 2000, month: 1, day: 1, hours: 0, minutes: 0, seconds: 62),
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

        func modify(
            of time: ISO_8824.GeneralizedTime,
            year: Int = 0,
            month: Int = 0,
            day: Int = 0,
            hours: Int = 0,
            minutes: Int = 0,
            seconds: Int = 0,
            fractionalSeconds: Double = 0
        ) throws -> ISO_8824.GeneralizedTime {
            try ISO_8824.GeneralizedTime(
                year: time.year + year,
                month: time.month + month,
                day: time.day + day,
                hours: time.hours + hours,
                minutes: time.minutes + minutes,
                seconds: time.seconds + seconds,
                fractionalSeconds: time.fractionalSeconds + fractionalSeconds
            )
        }

        let integerTransformable:
            [(ISO_8824.GeneralizedTime, Int) throws -> ISO_8824.GeneralizedTime] = [
                { try modify(of: $0, year: $1) },
                { try modify(of: $0, month: $1) },
                { try modify(of: $0, day: $1) },
                { try modify(of: $0, hours: $1) },
                { try modify(of: $0, minutes: $1) },
                { try modify(of: $0, seconds: $1) },
            ]

        var transformationsAndResults: [(ISO_8824.GeneralizedTime, ExpectedComparisonResult)] = []
        transformationsAndResults.append((original, .equal))

        for transform in integerTransformable {
            transformationsAndResults.append((try transform(original, 1), .greaterThan))
            transformationsAndResults.append((try transform(original, -1), .lessThan))
        }

        transformationsAndResults.append(
            (try modify(of: original, fractionalSeconds: 0.1), .greaterThan)
        )
        transformationsAndResults.append(
            (try modify(of: original, fractionalSeconds: -0.1), .lessThan)
        )

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
