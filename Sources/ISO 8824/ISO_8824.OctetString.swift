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

extension ISO_8824 {
    /// An OCTET STRING is a representation of a string of octets.
    public struct OctetString {
        // byte-discipline: [API-BYTE-004] opaque byte-domain payload — candidate for
        // `ArraySlice<Byte>`; retype deferred (judgment): this slice is the shared seam
        // with the swift-iso-8825 content-octet views and must retype in lockstep.
        /// The octets that make up this OCTET STRING.
        public var bytes: ArraySlice<UInt8>

        /// Construct an OCTET STRING from a sequence of bytes.
        ///
        /// - parameters:
        ///     - contentBytes: The bytes that make up this OCTET STRING.
        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) {
            self.bytes = contentBytes
        }
    }
}

extension ISO_8824.OctetString {
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/octetString``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .octetString
    }
}

extension ISO_8824.OctetString: Hashable {}

extension ISO_8824.OctetString: Sendable {}

extension ISO_8824.OctetString {
    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        let result = unsafe self.bytes.withUnsafeBytes { buffer in
            Result { () throws(E) -> R in unsafe try body(buffer) }
        }
        return try result.get()
    }
}

// -> ISO 8825: DERImplicitlyTaggable/BERImplicitlyTaggable conformances moved to
// swift-iso-8825 as retroactive extensions:
//   - init(derEncoded:withIdentifier:)  (primitive content-octet extraction)
//   - init(berEncoded:withIdentifier:)  (including the constructed-segment flattening walk)
//   - serialize(into:withIdentifier:)
