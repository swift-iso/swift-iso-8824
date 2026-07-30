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
    /// UTCTime represents a date and time.
    ///
    /// In DER format, this is always in the form of `YYMMDDHHMMSSZ`, with no support for fractional seconds.
    /// The time is always in the UTC time zone.
    ///
    /// ``ISO_8824/UTCTime`` differs from ``ISO_8824/GeneralizedTime`` in that it only has support for a two-digit year. This
    /// means that it can only encode dates between 1950 and 2049. For dates outside that range, prefer
    /// ``ISO_8824/GeneralizedTime``.
    public struct UTCTime: Hashable, Sendable {
        @usableFromInline var _year: Int
        @usableFromInline var _month: Int
        @usableFromInline var _day: Int
        @usableFromInline var _hours: Int
        @usableFromInline var _minutes: Int
        @usableFromInline var _seconds: Int

        /// Construct a new ``ISO_8824/UTCTime`` from individual components.
        ///
        /// - parameters:
        ///     - year: The numerical year. Must be in the range 1950 to 2049.
        ///     - month: The numerical month
        ///     - day: The numerical day
        ///     - hours: The numerical hours
        ///     - minutes: The numerical minutes
        ///     - seconds: The numerical seconds
        @inlinable
        public init(year: Int, month: Int, day: Int, hours: Int, minutes: Int, seconds: Int) throws(ISO_8824.Error) {
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
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/utcTime``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .utcTime
    }

    /// The numerical year.
    @inlinable
    public var year: Int {
        get {
            return self._year
        }
        set {
            self._year = newValue
            try! self._validate()
        }
    }

    /// The numerical month.
    @inlinable
    public var month: Int {
        get {
            return self._month
        }
        set {
            self._month = newValue
            try! self._validate()
        }
    }

    /// The numerical day.
    @inlinable
    public var day: Int {
        get {
            return self._day
        }
        set {
            self._day = newValue
            try! self._validate()
        }
    }

    /// The numerical hours.
    @inlinable
    public var hours: Int {
        get {
            return self._hours
        }
        set {
            self._hours = newValue
            try! self._validate()
        }
    }

    /// The numerical minutes.
    @inlinable
    public var minutes: Int {
        get {
            return self._minutes
        }
        set {
            self._minutes = newValue
            try! self._validate()
        }
    }

    /// The numerical seconds.
    @inlinable
    public var seconds: Int {
        get {
            return self._seconds
        }
        set {
            self._seconds = newValue
            try! self._validate()
        }
    }

    @inlinable
    package func _validate() throws(ISO_8824.Error) {
        // Validate that the structure is well-formed.
        // UTCTime can only hold years between 1950 and 2049.
        guard self._year >= 1950 && self._year < 2050 else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Invalid year for UTCTime \(self._year)")
        }

        // This also validates the month.
        guard let daysInMonth = ISO_8824.Time.daysInMonth(self._month, ofYear: self._year) else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Invalid month \(self._month) of year \(self.year) for UTCTime")
        }

        guard self._day >= 1 && self._day <= daysInMonth else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Invalid day \(self._day) of month \(self._month) for UTCTime")
        }

        guard self._hours >= 0 && self._hours < 24 else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Invalid hour for UTCTime \(self._hours)")
        }

        guard self._minutes >= 0 && self._minutes < 60 else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Invalid minute for UTCTime \(self._minutes)")
        }

        // We allow leap seconds here, but don't validate it.
        // This exposes us to potential confusion if we naively implement
        // comparison here. We should consider whether this needs to be transformable
        // to `Date` or similar.
        guard self._seconds >= 0 && self._seconds <= 61 else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Invalid seconds for UTCTime \(self._seconds)")
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
        if lhs.minutes < rhs.minutes { return true } else if lhs.minutes > rhs.minutes { return false }
        return lhs.seconds < rhs.seconds
    }
}

// -> ISO 8825: DERImplicitlyTaggable/BERImplicitlyTaggable conformances moved to
// swift-iso-8825 as retroactive extensions:
//   - init(derEncoded:withIdentifier:)  (content-octet extraction + utcTimeFromBytes)
//   - init(berEncoded:withIdentifier:)
//   - serialize(into:withIdentifier:)   (YYMMDDHHMMSSZ emission, 1950/2049 pivot)
