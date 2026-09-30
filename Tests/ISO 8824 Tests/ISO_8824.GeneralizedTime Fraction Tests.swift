import Testing

@testable import ISO_8824

@Suite
struct `Generalized time small fractions` {
    @Test(arguments: [(0.00001, "00001"), (0.000015, "000015"), (0.5, "5"), (0.0001, "0001")])
    func `a small fraction is written as plain digits`(_ fraction: Double, _ digits: String) throws {
        let time = try ISO_8824.GeneralizedTime(
            year: 2020, month: 3, day: 3, hours: 3, minutes: 3, seconds: 3,
            fractionalSeconds: fraction
        )
        #expect(String(decoding: time._rawFractionalSeconds, as: UTF8.self) == digits)
    }

    @Test(arguments: ["5e5", "5e-3", "+5", "5.5", "5 "])
    func `raw fractional seconds must be digits`(_ raw: String) {
        #expect(throws: ISO_8824.Error.self) {
            try ISO_8824.GeneralizedTime(
                year: 2020, month: 3, day: 3, hours: 3, minutes: 3, seconds: 3,
                rawFractionalSeconds: ArraySlice(raw.utf8)
            )
        }
    }
}
