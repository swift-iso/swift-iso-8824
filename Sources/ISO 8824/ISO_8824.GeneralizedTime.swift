extension ISO_8824 {

    public struct GeneralizedTime: Hashable, Sendable {
        @usableFromInline var _year: Int
        @usableFromInline var _month: Int
        @usableFromInline var _day: Int
        @usableFromInline var _hours: Int
        @usableFromInline var _minutes: Int
        @usableFromInline var _seconds: Int

        @usableFromInline var _fractionalSeconds: Double
        @usableFromInline var _rawFractionalSeconds: ArraySlice<UInt8>

        @inlinable
        public init(
            year: Int,
            month: Int,
            day: Int,
            hours: Int,
            minutes: Int,
            seconds: Int,
            fractionalSeconds: Double
        ) throws(ISO_8824.Error) {
            self._year = year
            self._month = month
            self._day = day
            self._hours = hours
            self._minutes = minutes
            self._seconds = seconds
            self._fractionalSeconds = fractionalSeconds
            self._rawFractionalSeconds = ArraySlice<UInt8>()
            try self._rawFractionalSeconds.append(fractionalSeconds: self._fractionalSeconds)

            try self._validate()
        }

        @inlinable
        public init(
            year: Int,
            month: Int,
            day: Int,
            hours: Int,
            minutes: Int,
            seconds: Int,
            rawFractionalSeconds: ArraySlice<UInt8>
        ) throws(ISO_8824.Error) {
            self._year = year
            self._month = month
            self._day = day
            self._hours = hours
            self._minutes = minutes
            self._seconds = seconds
            self._rawFractionalSeconds = rawFractionalSeconds
            self._fractionalSeconds = try Double(
                fromRawFractionalSeconds: self._rawFractionalSeconds
            )

            try self._validate()
        }
    }
}

extension ISO_8824.GeneralizedTime {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .generalizedTime
    }

    @inlinable
    public var year: Int {
        self._year
    }

    @inlinable
    public var month: Int {
        self._month
    }

    @inlinable
    public var day: Int {
        self._day
    }

    @inlinable
    public var hours: Int {
        self._hours
    }

    @inlinable
    public var minutes: Int {
        self._minutes
    }

    @inlinable
    public var seconds: Int {
        self._seconds
    }

    @inlinable
    public var fractionalSeconds: Double {
        self._fractionalSeconds
    }

    @inlinable
    public var rawFractionalSeconds: ArraySlice<UInt8> {
        self._rawFractionalSeconds
    }

    @inlinable
    package func _validate() throws(ISO_8824.Error) {

        guard self._year >= 0 && self._year <= 9999 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid year for GeneralizedTime \(self._year)"
            )
        }

        guard let daysInMonth = ISO_8824.Time.daysInMonth(self._month, ofYear: self._year) else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid month \(self._month) of year \(self.year) for GeneralizedTime"
            )
        }

        guard self._day >= 1 && self._day <= daysInMonth else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid day \(self._day) of month \(self._month) for GeneralizedTime"
            )
        }

        guard self._hours >= 0 && self._hours < 24 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid hour for GeneralizedTime \(self._hours)"
            )
        }

        guard self._minutes >= 0 && self._minutes < 60 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid minute for GeneralizedTime \(self._minutes)"
            )
        }

        guard self._seconds >= 0 && self._seconds <= 61 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid seconds for Generalized \(self._seconds)"
            )
        }

        guard self._fractionalSeconds >= 0 && self._fractionalSeconds < 1 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid fractional seconds for GeneralizedTime \(self._fractionalSeconds)"
            )
        }

        let convertedFractionalSeconds: Double?
        do throws(ISO_8824.Error) {
            convertedFractionalSeconds = try Double(
                fromRawFractionalSeconds: self._rawFractionalSeconds
            )
        } catch {
            convertedFractionalSeconds = nil
        }
        assert(convertedFractionalSeconds == self._fractionalSeconds)
    }
}

extension ISO_8824.GeneralizedTime: Comparable {
    @inlinable
    public static func < (lhs: ISO_8824.GeneralizedTime, rhs: ISO_8824.GeneralizedTime) -> Bool {
        if lhs.year < rhs.year { return true } else if lhs.year > rhs.year { return false }
        if lhs.month < rhs.month { return true } else if lhs.month > rhs.month { return false }
        if lhs.day < rhs.day { return true } else if lhs.day > rhs.day { return false }
        if lhs.hours < rhs.hours { return true } else if lhs.hours > rhs.hours { return false }
        if lhs.minutes < rhs.minutes {
            return true
        } else if lhs.minutes > rhs.minutes {
            return false
        }
        if lhs.seconds < rhs.seconds {
            return true
        } else if lhs.seconds > rhs.seconds {
            return false
        }
        if lhs.fractionalSeconds < rhs.fractionalSeconds {
            return true
        } else if lhs.fractionalSeconds > rhs.fractionalSeconds {
            return false
        }

        for (lhsByte, rhsByte) in zip(lhs.rawFractionalSeconds, rhs.rawFractionalSeconds) {
            if lhsByte != rhsByte {
                return lhsByte < rhsByte
            }
        }

        return lhs.rawFractionalSeconds.count < rhs.rawFractionalSeconds.count
    }
}
