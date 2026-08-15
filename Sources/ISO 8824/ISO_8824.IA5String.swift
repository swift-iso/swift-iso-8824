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
    /// IA5String represents a String made up of ASCII characters.
    ///
    /// This string will be validated when it is constructed, and will reject characters outside of this
    /// space.
    ///
    /// IA5String is deprecated for most use-cases and generally ``ISO_8824/UTF8String`` should be
    /// preferred.
    public struct IA5String {
        // byte-discipline: [API-BYTE-004] ASCII-strict payload (0x00–0x7F) — candidate for a
        // typed ASCII substrate (`ASCII.Code`); retype deferred (judgment): shared seam with
        // swift-iso-8825.
        /// The raw bytes that make up this string.
        public var bytes: ArraySlice<UInt8> {
            didSet {
                precondition(Self._isValid(self.bytes))
            }
        }

        /// Construct an IA5String from raw bytes.
        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) throws(ISO_8824.Error) {
            self.bytes = contentBytes
            guard Self._isValid(self.bytes) else {
                throw ISO_8824.Error.invalidStringRepresentation(
                    reason: "Invalid bytes for IA5String"
                )
            }
        }
    }
}

extension ISO_8824.IA5String {
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/ia5String``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .ia5String
    }

    /// Construct an IA5String from a String.
    @inlinable
    public init(_ string: String) throws(ISO_8824.Error) {
        self.bytes = ArraySlice(string.utf8)

        guard Self._isValid(self.bytes) else {
            throw ISO_8824.Error.invalidStringRepresentation(reason: "Invalid bytes for IA5String")
        }
    }

    @inlinable
    public func withUnsafeBytes<R, E: Swift.Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        let result = unsafe self.bytes.withUnsafeBytes { buffer in
            Result { () throws(E) -> R in unsafe try body(buffer) }
        }
        return try result.get()
    }

    @inlinable
    package static func _isValid(_ bytes: ArraySlice<UInt8>) -> Bool {
        // Valid IA5Strings are ASCII characters.
        bytes.allSatisfy { $0 < 128 }
    }
}

extension ISO_8824.IA5String: Hashable {}

extension ISO_8824.IA5String: Sendable {}

extension ISO_8824.IA5String: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        // REASON: ExpressibleBy*Literal requirement is non-throwing; literal validity is not
        // statically checkable. Throwing form is `init(contentBytes:)`.
        // swiftlint:disable:next force_try
        try! self.init(contentBytes: ArraySlice(value.utf8))
    }
}

// -> ISO 8825: DERImplicitlyTaggable/BERImplicitlyTaggable conformances moved to
// swift-iso-8825 as retroactive extensions:
//   - init(derEncoded:withIdentifier:), init(berEncoded:withIdentifier:) (both re-validate)
//   - serialize(into:withIdentifier:) (via the OctetString content-octet emission)
