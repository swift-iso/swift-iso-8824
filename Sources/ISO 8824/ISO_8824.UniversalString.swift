// ===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftASN1 open source project
//
// Copyright (c) 2021 Apple Inc. and the SwiftASN1 project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftASN1 project authors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

extension ISO_8824 {
    /// UniversalString is an uncommon ASN.1 string type.
    ///
    /// This module represents a UniversalString as an opaque sequence of bytes.
    public struct UniversalString {
        // byte-discipline: [API-BYTE-004] opaque byte-domain payload — candidate for
        // `ArraySlice<Byte>`; retype deferred (judgment): shared seam with swift-iso-8825.
        /// The raw bytes that make up this string.
        public var bytes: ArraySlice<UInt8>

        /// Construct a UniversalString from raw bytes.
        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) {
            self.bytes = contentBytes
        }
    }
}

extension ISO_8824.UniversalString {
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/universalString``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .universalString
    }

    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        let result = self.bytes.withUnsafeBytes { buffer in
            Result { () throws(E) -> R in unsafe try body(buffer) }
        }
        return try result.get()
    }
}

extension ISO_8824.UniversalString: Hashable {}

extension ISO_8824.UniversalString: Sendable {}

extension ISO_8824.UniversalString: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        self.init(contentBytes: ArraySlice(value.utf8))
    }
}

// -> ISO 8825: DERImplicitlyTaggable/BERImplicitlyTaggable conformances moved to
// swift-iso-8825 as retroactive extensions:
//   - init(derEncoded:withIdentifier:), init(berEncoded:withIdentifier:)
//   - serialize(into:withIdentifier:) (via the OctetString content-octet emission)
