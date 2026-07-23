//===----------------------------------------------------------------------===//
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
//===----------------------------------------------------------------------===//

extension ISO_8824 {
    /// BMPString is an uncommon ASN.1 string type.
    ///
    /// This module represents a BMPString as an opaque sequence of bytes.
    public struct BMPString {
        /// The raw bytes that make up this string.
        // byte-discipline: [API-BYTE-004] opaque byte-domain payload (UTF-16BE code units) —
        // candidate for `ArraySlice<Byte>`; retype deferred (judgment): shared seam with
        // swift-iso-8825.
        public var bytes: ArraySlice<UInt8>

        /// Construct a BMPString from raw bytes.
        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) {
            self.bytes = contentBytes
        }
    }
}

extension ISO_8824.BMPString {
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/bmpString``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .bmpString
    }

    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R {
        let result = unsafe self.bytes.withUnsafeBytes { buffer in
            Result { () throws(E) -> R in unsafe try body(buffer) }
        }
        return try result.get()
    }
}

extension ISO_8824.BMPString: Hashable {}

extension ISO_8824.BMPString: Sendable {}

extension ISO_8824.BMPString: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        guard
            value.utf16.allSatisfy({ codeUnit in
                !(0xD800...0xDFFF).contains(codeUnit)
            })
        else {
            fatalError("BMPString cannot contain characters outside the Basic Multilingual Plane: '\(value)'")
        }

        self.init(
            contentBytes: ArraySlice(
                value.utf16.flatMap { codeUnit in
                    [UInt8(truncatingIfNeeded: codeUnit >> 8), UInt8(truncatingIfNeeded: codeUnit)]
                }
            )
        )
    }
}

// -> ISO 8825: DERImplicitlyTaggable/BERImplicitlyTaggable conformances moved to
// swift-iso-8825 as retroactive extensions:
//   - init(derEncoded:withIdentifier:), init(berEncoded:withIdentifier:)
//   - serialize(into:withIdentifier:) (via the OctetString content-octet emission)
