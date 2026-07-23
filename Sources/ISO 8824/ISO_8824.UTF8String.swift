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
    /// A UTF8String represents a string made up of UTF-8 bytes.
    public struct UTF8String {
        /// The raw bytes that make up this string.
        // byte-discipline: [API-BYTE-004] byte-domain payload (UTF-8, may exceed 0x7F) —
        // candidate for `ArraySlice<Byte>`; retype deferred (judgment): shared seam with
        // the swift-iso-8825 content-octet views.
        public var bytes: ArraySlice<UInt8>

        /// Construct a UTF8STRING from raw bytes.
        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) {
            self.bytes = contentBytes
        }
    }
}

extension ISO_8824.UTF8String {
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/utf8String``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .utf8String
    }

    /// Construct a UTF8STRING from a String.
    @inlinable
    public init(_ string: String) {
        self.init(contentBytes: ArraySlice(string.utf8))
    }

    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R {
        let result = unsafe self.bytes.withUnsafeBytes { buffer in
            Result { () throws(E) -> R in unsafe try body(buffer) }
        }
        return try result.get()
    }
}

extension ISO_8824.UTF8String: Hashable {}

extension ISO_8824.UTF8String: Sendable {}

extension ISO_8824.UTF8String: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        self.init(contentBytes: ArraySlice(value.utf8))
    }
}

// -> ISO 8825: DERImplicitlyTaggable/BERImplicitlyTaggable conformances moved to
// swift-iso-8825 as retroactive extensions:
//   - init(derEncoded:withIdentifier:), init(berEncoded:withIdentifier:)
//   - serialize(into:withIdentifier:) (via the OctetString content-octet emission)
