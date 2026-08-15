// ===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftASN1 open source project
//
// Copyright (c) 2019-2020 Apple Inc. and the SwiftASN1 project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftASN1 project authors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

extension ISO_8824.Integer {
    /// A big-endian `Collection` of bytes representing a fixed width integer.
    public struct Bytes<Integer: FixedWidthInteger> {
        @usableFromInline var integer: Integer

        /// Construct an ``ISO_8824/Integer/Bytes`` collection representing the bytes of this integer.
        @inlinable
        public init(_ integer: Integer) {
            self.integer = integer
        }
    }
}

extension ISO_8824.Integer.Bytes: Hashable {}

extension ISO_8824.Integer.Bytes: Sendable where Integer: Sendable {}

extension ISO_8824.Integer.Bytes: RandomAccessCollection {
    @inlinable
    public var startIndex: Index {
        return Index(byteNumber: Int(self.integer.neededBytes))
    }

    @inlinable
    public var endIndex: Index {
        return Index(byteNumber: 0)
    }

    @inlinable
    public var count: Int {
        return Int(self.integer.neededBytes)
    }

    @inlinable
    public subscript(index: Index) -> UInt8 {
        // We perform the bitwise operations in magnitude space.
        let shifted = Integer.Magnitude(truncatingIfNeeded: self.integer) >> index._shift
        let masked = shifted & 0xFF
        return UInt8(masked)
    }
}

extension FixedWidthInteger {
    // Bytes needed to store a given integer.
    //
    // NOTE: upstream declares this in ASN1.swift, which is in swift-iso-8825's heritage
    // partition; it is duplicated here (value law) because ``ISO_8824/Integer/Bytes``
    // requires it. 8825's copy stays with its heritage file — dedupe is a lead decision.
    /// Encoded-representation seam shared with ISO 8825 (X.690): content-octet length
    /// computation for integer serialization.
    @inlinable
    public var neededBytes: Int {
        let neededBits = self.bitWidth - self.leadingZeroBitCount
        return (neededBits + 7) / 8
    }
}

extension RandomAccessCollection where Element == UInt8 {
    /// Encoded-representation seam shared with ISO 8825 (X.690): minimal-octets
    /// normalization for integer content octets.
    @inlinable
    public func _trimLeadingExcessBytes() -> SubSequence {
        var slice = self[...]
        guard let first = slice.first else {
            // Easy case, empty.
            return slice
        }

        let wholeByte: UInt8

        switch first {
        case 0:
            wholeByte = 0

        case 0xFF:
            wholeByte = 0xFF

        default:
            // We're already fine, this is maximally compact. We need the whole thing.
            return slice
        }

        // We never trim this to less than one byte, as that's always the smallest representation.
        while slice.count > 1 {
            // If the first byte is equal to our original first byte, and the top bit
            // of the next byte is also equal to that, then we need to drop the byte and
            // go again.
            if slice.first != wholeByte {
                break
            }

            guard let second = slice.dropFirst().first else {
                preconditionFailure("Loop condition violated: must be at least two bytes left")
            }

            if second & 0x80 != wholeByte & 0x80 {
                // Different top bit, we need the leading byte.
                break
            }

            // Both the first byte and the top bit of the next are all zero or all 1, drop the leading
            // byte.
            slice = slice.dropFirst()
        }

        return slice
    }
}

extension UInt8 {
    /// Encoded-representation seam shared with ISO 8825 (X.690): sign-bit probe used by
    /// the integer content-octet discipline.
    @inlinable
    public var _topBitSet: Bool {
        return (self & 0x80) != 0
    }
}

// byte-discipline: [API-BYTE-004] arithmetic-domain — IntegerBytes.Element stays UInt8
// (shift/mask magnitude math per the rubric's arithmetic rows).
