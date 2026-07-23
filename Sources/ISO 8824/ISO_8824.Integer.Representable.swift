//===----------------------------------------------------------------------===//
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
//===----------------------------------------------------------------------===//

extension ISO_8824.Integer {
    /// A protocol that represents any internal object that can present itself as an INTEGER, or be
    /// constructed from an INTEGER's big-endian magnitude bytes.
    ///
    /// This protocol exists to allow users to handle the possibility of integers that cannot fit into
    /// UInt64 or Int64. The standard fixed-width integer types conform by default; users can conform
    /// their preferred arbitrary-width integer type as well.
    public protocol Representable {
        associatedtype IntegerBytes: RandomAccessCollection where IntegerBytes.Element == UInt8

        /// Whether this type can represent signed integers.
        ///
        /// If this is set to false, a serializer and parser must automatically handle padding
        /// with leading zero bytes as needed.
        static var isSigned: Bool { get }

        /// Provide the big-endian bytes corresponding to this integer.
        func withBigEndianIntegerBytes<ReturnType, E: Swift.Error>(_ body: (IntegerBytes) throws(E) -> ReturnType) throws(E) -> ReturnType
    }
}

// MARK: - Auto-conformance for FixedWidthInteger with fixed width magnitude.
extension ISO_8824.Integer.Representable where Self: FixedWidthInteger {
    @inlinable
    public func withBigEndianIntegerBytes<ReturnType, E: Swift.Error>(
        _ body: (ISO_8824.Integer.Bytes<Self>) throws(E) -> ReturnType
    ) throws(E) -> ReturnType {
        return try body(ISO_8824.Integer.Bytes(self))
    }
}

extension Int8: ISO_8824.Integer.Representable {}

extension UInt8: ISO_8824.Integer.Representable {}

extension Int16: ISO_8824.Integer.Representable {}

extension UInt16: ISO_8824.Integer.Representable {}

extension Int32: ISO_8824.Integer.Representable {}

extension UInt32: ISO_8824.Integer.Representable {}

extension Int64: ISO_8824.Integer.Representable {}

extension UInt64: ISO_8824.Integer.Representable {}

extension Int: ISO_8824.Integer.Representable {}

extension UInt: ISO_8824.Integer.Representable {}

// -> ISO 8825: moved to swift-iso-8825 with the DER/BER conformance bodies:
//   - the upstream protocol's refinement of DERImplicitlyTaggable & BERImplicitlyTaggable
//     (8825 declares the codec-facing refinement of `ISO_8824.Integer.Representable`)
//   - requirement `init(derIntegerBytes:)` and `init(berIntegerBytes:)` (content-octet decode,
//     X.690 §8.3 minimal-octets checks, unsigned top-byte stripping, sign extension)
//   - default impls `init(derEncoded:withIdentifier:)`, `init(berEncoded:withIdentifier:)`,
//     `serialize(into:withIdentifier:)`
//   - the FixedWidthInteger auto-impls of `init(derIntegerBytes:)` / `init(berIntegerBytes:)`
//     (including `Self(bigEndianBytes:)` and the 1-extension loop)
