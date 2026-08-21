extension ISO_8824 {

    public struct UTCTime: Hashable, Sendable {
        @usableFromInline var _year: Int
        @usableFromInline var _month: Int
        @usableFromInline var _day: Int
        @usableFromInline var _hours: Int
        @usableFromInline var _minutes: Int
        @usableFromInline var _seconds: Int

        @inlinable
        public init(
            year: Int,
            month: Int,
            day: Int,
            hours: Int,
            minutes: Int,
            seconds: Int
        ) throws(ISO_8824.Error) {
            self._year = year
            self._month = month
            self._day = day
            self._hours = hours
            self._minutes = minutes
            self._seconds = seconds

            try self._validate()
        }
    }
}

extension ISO_8824.UTCTime {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .utcTime
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
    package func _validate() throws(ISO_8824.Error) {

        guard self._year >= 1950 && self._year < 2050 else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Invalid year for UTCTime \(self._year)")
        }

        guard let daysInMonth = ISO_8824.Time.daysInMonth(self._month, ofYear: self._year) else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid month \(self._month) of year \(self.year) for UTCTime"
            )
        }

        guard self._day >= 1 && self._day <= daysInMonth else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid day \(self._day) of month \(self._month) for UTCTime"
            )
        }

        guard self._hours >= 0 && self._hours < 24 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid hour for UTCTime \(self._hours)"
            )
        }

        guard self._minutes >= 0 && self._minutes < 60 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid minute for UTCTime \(self._minutes)"
            )
        }

        guard self._seconds >= 0 && self._seconds <= 61 else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid seconds for UTCTime \(self._seconds)"
            )
        }
    }
}

extension ISO_8824.UTCTime: Comparable {
    @inlinable
    public static func < (lhs: ISO_8824.UTCTime, rhs: ISO_8824.UTCTime) -> Bool {
        if lhs.year < rhs.year { return true } else if lhs.year > rhs.year { return false }
        if lhs.month < rhs.month { return true } else if lhs.month > rhs.month { return false }
        if lhs.day < rhs.day { return true } else if lhs.day > rhs.day { return false }
        if lhs.hours < rhs.hours { return true } else if lhs.hours > rhs.hours { return false }
        if lhs.minutes < rhs.minutes {
            return true
        } else if lhs.minutes > rhs.minutes {
            return false
        }
        return lhs.seconds < rhs.seconds
    }
}
