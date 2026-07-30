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
    /// An ``ISO_8824/Identifier`` is a representation of the abstract notion of an ASN.1 identifier.
    public struct Identifier {
        /// The base tag.
        public var tagNumber: UInt

        /// The class of the tag.
        public var tagClass: Class

        /// Produces a tag from components.
        ///
        /// - parameters:
        ///     - number: The tag number.
        ///     - tagClass: The class of the ASN.1 tag.
        @inlinable
        public init(tagWithNumber number: UInt, tagClass: Class) {
            self.tagNumber = number
            self.tagClass = tagClass
        }
    }
}

extension ISO_8824.Identifier {
    @inlinable
    package var _shortForm: UInt8? {
        // An ASN.1 identifier can be encoded in short form iff the tag number is strictly
        // less than 0x1f.
        guard self.tagNumber < 0x1f else { return nil }

        var baseNumber = UInt8(truncatingIfNeeded: self.tagNumber)
        baseNumber |= self.tagClass._topByteFlags
        return baseNumber
    }

    @inlinable
    package init(shortIdentifier: UInt8) {
        precondition(shortIdentifier & 0x1F != 0x1F)
        self.init(
            tagWithNumber: UInt(shortIdentifier & 0x1f),
            tagClass: Class(topByteInWireFormat: shortIdentifier)
        )
    }
}

extension ISO_8824.Identifier {
    /// This tag represents an OBJECT IDENTIFIER.
    public static let objectIdentifier = ISO_8824.Identifier(shortIdentifier: 0x06)

    /// This tag represents a BIT STRING.
    public static let bitString = ISO_8824.Identifier(shortIdentifier: 0x03)

    /// This tag represents an OCTET STRING.
    public static let octetString = ISO_8824.Identifier(shortIdentifier: 0x04)

    /// This tag represents an INTEGER.
    public static let integer = ISO_8824.Identifier(shortIdentifier: 0x02)

    /// This tag represents a SEQUENCE or SEQUENCE OF.
    public static let sequence = ISO_8824.Identifier(shortIdentifier: 0x30)

    /// This tag represents a SET or SET OF.
    public static let set = ISO_8824.Identifier(shortIdentifier: 0x31)

    /// This tag represents an ASN.1 NULL.
    public static let null = ISO_8824.Identifier(shortIdentifier: 0x05)

    /// This tag represents a BOOLEAN.
    public static let boolean = ISO_8824.Identifier(shortIdentifier: 0x01)

    /// This tag represents an ENUMERATED.
    public static let enumerated = ISO_8824.Identifier(shortIdentifier: 0x0a)

    /// This tag represents a UTF8STRING.
    public static let utf8String = ISO_8824.Identifier(shortIdentifier: 0x0c)

    /// This tag represents a NumericString.
    public static let numericString = ISO_8824.Identifier(shortIdentifier: 0x12)

    /// This tag represents a PrintableString.
    public static let printableString = ISO_8824.Identifier(shortIdentifier: 0x13)

    /// This tag represents a TeletexString.
    public static let teletexString = ISO_8824.Identifier(shortIdentifier: 0x14)

    /// This tag represents a VideotexString.
    public static let videotexString = ISO_8824.Identifier(shortIdentifier: 0x15)

    /// This tag represents an IA5String.
    public static let ia5String = ISO_8824.Identifier(shortIdentifier: 0x16)

    /// This tag represents a GraphicString.
    public static let graphicString = ISO_8824.Identifier(shortIdentifier: 0x19)

    /// This tag represents a VisibleString.
    public static let visibleString = ISO_8824.Identifier(shortIdentifier: 0x1a)

    /// This tag represents a GeneralString.
    public static let generalString = ISO_8824.Identifier(shortIdentifier: 0x1b)

    /// This tag represents a UniversalString.
    public static let universalString = ISO_8824.Identifier(shortIdentifier: 0x1c)

    /// This tag represents a BMPString.
    public static let bmpString = ISO_8824.Identifier(shortIdentifier: 0x1e)

    /// This tag represents a GeneralizedTime.
    public static let generalizedTime = ISO_8824.Identifier(shortIdentifier: 0x18)

    /// This tag represents a UTCTime.
    public static let utcTime = ISO_8824.Identifier(shortIdentifier: 0x17)
}

extension ISO_8824.Identifier: Hashable {}

extension ISO_8824.Identifier: Sendable {}

extension ISO_8824.Identifier: CustomStringConvertible {
    @inlinable
    public var description: String {
        return "ISO_8824.Identifier(tagNumber: \(self.tagNumber), tagClass: \(self.tagClass))"
    }
}

// -> ISO 8825: `extension Array where Element == UInt8 { mutating func writeIdentifier(_:constructed:) }`
// (X.690 identifier-octet serialization) moved to swift-iso-8825 with the DER/BER conformance
// bodies. Its long-form path consumed `writeUsing7BitBytesASN1Discipline(unsignedInteger:)`,
// which REMAINS here (ISO_8824.ObjectIdentifier.swift) as the canonical base-128 component
// packing; 8825 needs cross-package visibility to it (currently internal — lead decision).
