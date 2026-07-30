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

extension ISO_8824.Integer.Bytes {
    public struct Index {
        @usableFromInline
        var _byteNumber: Int

        @inlinable
        package init(byteNumber: Int) {
            self._byteNumber = byteNumber
        }
    }
}

extension ISO_8824.Integer.Bytes.Index {
    @inlinable
    package var _shift: Integer {
        // As byte number 0 is the end index, the byte number is one byte too large for the shift.
        return Integer((self._byteNumber - 1) * 8)
    }
}

extension ISO_8824.Integer.Bytes.Index: Hashable {}

extension ISO_8824.Integer.Bytes.Index: Sendable {}

extension ISO_8824.Integer.Bytes.Index: Comparable {
    // Comparable here is backwards to the original ordering.
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs._byteNumber > rhs._byteNumber
    }

    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs._byteNumber < rhs._byteNumber
    }

    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs._byteNumber >= rhs._byteNumber
    }

    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs._byteNumber <= rhs._byteNumber
    }
}

extension ISO_8824.Integer.Bytes.Index: Strideable {
    @inlinable
    public func advanced(by n: Int) -> Self {
        return Self(byteNumber: self._byteNumber - n)
    }

    @inlinable
    public func distance(to other: Self) -> Int {
        // Remember that early indices have high byte numbers and later indices have low ones.
        return self._byteNumber - other._byteNumber
    }
}
