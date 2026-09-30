extension ISO_8824 {

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

    @inlinable
    package mutating func append(fractionalSeconds: Double) throws(ISO_8824.Error) {

        guard fractionalSeconds >= 0 && fractionalSeconds < 1 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid fractional seconds: \(fractionalSeconds)"
            )
        }

        if fractionalSeconds != 0 {
            var fractionalSecondsAsString = String(fractionalSeconds)
            if let exponentIndex = fractionalSecondsAsString.firstIndex(of: "e"),
                let exponent = Int(fractionalSecondsAsString[fractionalSecondsAsString.index(after: exponentIndex)...])
            {
                let digits = fractionalSecondsAsString[..<exponentIndex].filter { $0 != "." }
                fractionalSecondsAsString = "0." + String(repeating: "0", count: -exponent - 1) + digits
            }

            assert(fractionalSecondsAsString.starts(with: "0."), "Invalid fractional seconds")
            assert(fractionalSecondsAsString.last != "0", "Trailing zeros in fractional seconds")

            self.append(contentsOf: fractionalSecondsAsString.utf8.dropFirst(2))
        }
    }
}

extension Double {

    @inlinable
    package init(
        fromRawFractionalSeconds rawFractionalSeconds: ArraySlice<UInt8>
    ) throws(ISO_8824.Error) {
        if rawFractionalSeconds.count == 0 {
            self = 0
            return
        }

        guard rawFractionalSeconds.allSatisfy({ $0 >= UInt8(ascii: "0") && $0 <= UInt8(ascii: "9") }) else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid raw fractional seconds"
            )
        }

        if rawFractionalSeconds.last == UInt8(ascii: "0") {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Trailing zeros in raw fractional seconds"
            )
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
