import ISO_8824
import Testing

@Suite
struct `ASN.1 time boundaries` {
    private func utc(_ year: Int, _ month: Int = 1, _ day: Int = 1, _ h: Int = 0, _ m: Int = 0, _ s: Int = 0) throws(ISO_8824.Error) -> ISO_8824.UTCTime {
        try ISO_8824.UTCTime(year: year, month: month, day: day, hours: h, minutes: m, seconds: s)
    }

    private func generalized(_ year: Int, _ month: Int, _ day: Int) throws(ISO_8824.Error) -> ISO_8824.GeneralizedTime {
        try ISO_8824.GeneralizedTime(year: year, month: month, day: day, hours: 0, minutes: 0, seconds: 0, fractionalSeconds: 0)
    }

    @Test
    func `UTCTime accepts exactly 1950 through 2049`() throws {
        _ = try utc(1950)
        _ = try utc(2049, 12, 31, 23, 59, 59)
        #expect(throws: ISO_8824.Error.self) { try utc(1949, 12, 31, 23, 59, 59) }
        #expect(throws: ISO_8824.Error.self) { try utc(2050) }
    }

    @Test
    func `February 29 follows the Gregorian leap rules`() throws {
        _ = try generalized(2000, 2, 29)
        _ = try generalized(2024, 2, 29)
        #expect(throws: ISO_8824.Error.self) { try generalized(1900, 2, 29) }
        #expect(throws: ISO_8824.Error.self) { try generalized(2100, 2, 29) }
        #expect(throws: ISO_8824.Error.self) { try generalized(2023, 2, 29) }
    }

    @Test
    func `each component rejects the first value past its range`() {
        #expect(throws: ISO_8824.Error.self) { try utc(2000, 0) }
        #expect(throws: ISO_8824.Error.self) { try utc(2000, 13) }
        #expect(throws: ISO_8824.Error.self) { try utc(2000, 4, 31) }
        #expect(throws: ISO_8824.Error.self) { try utc(2000, 1, 0) }
        #expect(throws: ISO_8824.Error.self) { try utc(2000, 1, 1, 24) }
        #expect(throws: ISO_8824.Error.self) { try utc(2000, 1, 1, 0, 60) }
        #expect(throws: ISO_8824.Error.self) { try utc(2000, 1, 1, 0, 0, -1) }
    }
}
