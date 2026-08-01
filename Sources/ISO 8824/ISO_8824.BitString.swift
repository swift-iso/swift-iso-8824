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
    /// A bitstring is a representation of a sequence of bits.
    ///
    /// In ASN.1, bitstrings serve two different use-cases. The first is as arbitrary-length sequences of bits.
    /// These are typically used to encode cryptographic keys, such as RSA keys. The second is as a form of bitset.
    ///
    /// In the case of a bitset, DER has additional requirements as to how to represent the object. This type does not
    /// enforce those additional rules: users are expected to implement that validation themselves.
    public struct BitString {
        // byte-discipline: [API-BYTE-004] byte-domain payload with bitwise-only validation —
        // candidate for `ArraySlice<Byte>`; retype deferred (judgment): shared seam with the
        // swift-iso-8825 content-octet views, must retype in lockstep.
        @usableFromInline var _bytes: ArraySlice<UInt8>
        @usableFromInline var _paddingBits: Int

        /// Construct an ``ISO_8824/BitString`` from raw components.
        ///
        /// - parameters:
        ///     - bytes: The bytes to represent this bitstring
        ///     - paddingBits: The number of bits in the trailing byte that are not actually part of this bitstring.
        @inlinable
        public init(bytes: ArraySlice<UInt8>, paddingBits: Int = 0) throws(ISO_8824.Error) {
            self._bytes = bytes
            self._paddingBits = paddingBits
            try self._validate()
        }
    }
}

extension ISO_8824.BitString {
    /// The raw bytes that make up this bitstring.
    ///
    /// The last ``paddingBits`` number of bits in the final octet of this byte sequence must be zero.
    @inlinable
    public var bytes: ArraySlice<UInt8> {
        self._bytes
    }

    /// The number of bits in the last octet of ``bytes`` that are not part of this bitstring.
    ///
    /// The excluded bits are the least significant bits.
    ///
    /// If ``bytes`` is empty then this value must be 0.
    @inlinable
    public var paddingBits: Int {
        self._paddingBits
    }
}

extension ISO_8824.BitString {
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/bitString``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .bitString
    }

    @inlinable
    package func _validate() throws(ISO_8824.Error) {
        guard (0..<8).contains(self.paddingBits) else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid number of padding bits for BitString: \(self.paddingBits)"
            )
        }

        guard let finalByte = self.bytes.last else {
            if self.paddingBits != 0 {
                // If there are no bytes, there must be no padding bits.
                throw ISO_8824.Error.invalidASN1Object(
                    reason: "Invalid number of padding bits for BitString: \(self.paddingBits)"
                )
            }

            return
        }

        // Oooh, bit twiddling.
        //
        // All joking aside, this sets the bottom `self.paddingBits` to 1.
        let mask = ~(UInt8.max << self.paddingBits)
        if (finalByte & mask) != 0 {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid padding bits in BitString: \(self.paddingBits) of padding, \(finalByte) final byte"
            )
        }
    }
}

extension ISO_8824.BitString: Hashable {}

extension ISO_8824.BitString: Sendable {}

extension ISO_8824.BitString {
    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(_ body: (UnsafeRawBufferPointer) throws(E) -> R) throws(E) -> R {
        let result = unsafe self.bytes.withUnsafeBytes { buffer in
            Result { () throws(E) -> R in unsafe try body(buffer) }
        }
        return try result.get()
    }
}

// -> ISO 8825: DERImplicitlyTaggable/BERImplicitlyTaggable conformances moved to
// swift-iso-8825 as retroactive extensions:
//   - init(derEncoded:withIdentifier:)  (leading padding-octet decode + _validate)
//   - init(berEncoded:withIdentifier:)  (constructed-encoding rejection)
//   - serialize(into:withIdentifier:)   (padding-octet prefix emission)
