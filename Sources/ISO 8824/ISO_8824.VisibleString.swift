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
    /// VisibleString represents a String made up of bytes that are printable
    /// 7-bit ASCII characters (codes 32-126), including letters, digits, spaces, punctuation
    /// and not including control characters.
    ///
    /// This string will be validated when it is constructed, and will reject characters outside of this
    /// space.
    public struct VisibleString {
        // byte-discipline: [API-BYTE-004] ASCII-strict subset payload — candidate for a typed
        // ASCII substrate (`ASCII.Code`); retype deferred (judgment): shared seam with
        // swift-iso-8825.
        /// The raw bytes that make up this string.
        public var bytes: ArraySlice<UInt8> {
            didSet {
                precondition(Self._isValid(self.bytes))
            }
        }

        /// Construct a VisibleString from raw bytes.
        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) throws(ISO_8824.Error) {
            self.bytes = contentBytes
            guard Self._isValid(self.bytes) else {
                throw ISO_8824.Error.invalidStringRepresentation(
                    reason: "Invalid bytes for VisibleString"
                )
            }
        }
    }
}

extension ISO_8824.VisibleString {
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/visibleString``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .visibleString
    }

    /// Construct a VisibleString from a String.
    @inlinable
    public init(_ string: String) throws(ISO_8824.Error) {
        self.bytes = ArraySlice(string.utf8)

        guard Self._isValid(self.bytes) else {
            throw ISO_8824.Error.invalidStringRepresentation(
                reason: "Invalid bytes for VisibleString"
            )
        }
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

    @inlinable
    package static func _isValid(_ bytes: ArraySlice<UInt8>) -> Bool {
        bytes.allSatisfy {
            return 32 <= $0 && $0 <= 126
        }
    }
}

extension ISO_8824.VisibleString: Hashable {}

extension ISO_8824.VisibleString: Sendable {}

extension ISO_8824.VisibleString: ExpressibleByStringLiteral {
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
