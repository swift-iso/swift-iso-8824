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
    /// An Object Identifier is a representation of some kind of object.
    ///
    /// It represents a node in an OID hierarchy, and is usually represented as an ordered sequence of numbers. Object identifiers
    /// form a nested tree of namespaces.
    ///
    /// The most common way to construct an OID is to create one using an array literal. For example, the OID 2.5.4.41 can be created
    /// as:
    ///
    /// ```swift
    /// let name: ISO_8824.ObjectIdentifier = [2, 5, 4, 41]
    /// ```
    ///
    /// This object also has a number of pre-existing values defined in namespaces. Users are encouraged to create their own namespaces to
    /// make it easier to use OIDs in their own serialization code.
    public struct ObjectIdentifier {
        // byte-discipline: [API-BYTE-004] arithmetic-domain — the packing/unpacking helpers
        // below do shift/mask accumulation, so the substrate stays UInt8 per the rubric.
        /// The canonical packed component bytes (base-128 subidentifier discipline).
        ///
        /// Encoded-representation seam shared with ISO 8825 (X.690): the transfer-syntax
        /// package serializes OID content octets directly from this view.
        public private(set) var bytes: ArraySlice<UInt8>

        @usableFromInline
        init(_bytes bytes: ArraySlice<UInt8>) {
            self.bytes = bytes
        }

        /// Creates an object identifier from its packed encoded form, validating the
        /// base-128 subidentifier discipline.
        ///
        /// Encoded-representation seam shared with ISO 8825 (X.690): the transfer-syntax
        /// package constructs OIDs from decoded content octets through this entry point.
        public init(encodedForm bytes: ArraySlice<UInt8>) throws(ISO_8824.Error) {
            try Self.validateObjectIdentifierInEncodedForm(bytes)
            self.bytes = bytes
        }
    }
}

extension ISO_8824.ObjectIdentifier {
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/objectIdentifier``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .objectIdentifier
    }

    /// Validates that a packed component representation obeys the base-128 subidentifier discipline.
    ///
    /// Encoded-representation seam shared with ISO 8825 (X.690): the transfer-syntax
    /// package validates OID content octets through this entry point.
    @inlinable
    public static func validateObjectIdentifierInEncodedForm(_ content: ArraySlice<UInt8>) throws(ISO_8824.Error) {
        var content = content

        guard content.count >= 1 else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Zero components in OID")
        }

        while content.count > 0 {
            _ = try content.readUIntUsing8BitBytesASN1Discipline()
        }
    }

    /// An array representing the OID components
    @inlinable
    public var oidComponents: [UInt] {
        var content = bytes
        // We have to parse the content. From the spec:
        //
        // > Each subidentifier is represented as a series of (one or more) octets. Bit 8 of each octet indicates whether it
        // > is the last in the series: bit 8 of the last octet is zero, bit 8 of each preceding octet is one. Bits 7 to 1 of
        // > the octets in the series collectively encode the subidentifier. Conceptually, these groups of bits are concatenated
        // > to form an unsigned binary number whose most significant bit is bit 7 of the first octet and whose least significant
        // > bit is bit 1 of the last octet. The subidentifier shall be encoded in the fewest possible octets[...].
        // >
        // > The number of subidentifiers (N) shall be one less than the number of object identifier components in the object identifier
        // > value being encoded.
        // >
        // > The numerical value of the first subidentifier is derived from the values of the first _two_ object identifier components
        // > in the object identifier value being encoded, using the formula:
        // >
        // >  (X*40) + Y
        // >
        // > where X is the value of the first object identifier component and Y is the value of the second object identifier component.
        //
        // Yeah, this is a bit bananas, but basically there are only 3 first OID components (0, 1, 2) and there are no more than 39 children
        // of nodes 0 or 1. In my view this is too clever by half, but the ITU.T didn't ask for my opinion when they were coming up with this
        // scheme, likely because I was in middle school at the time.
        var subcomponents = [UInt]()
        while content.count > 0 {
            do throws(ISO_8824.Error) {
                subcomponents.append(try content.readUIntUsing8BitBytesASN1Discipline())
            } catch {
                preconditionFailure(
                    """
                    Error while trying to read UInt using 8 bit ASN.1 Discipline: \(error). \
                    ISO_8824.ObjectIdentifier validates the encoded format during initialisation and this should be impossible.
                    """
                )
            }
        }

        // Now we need to expand the subcomponents out. This means we need to undo the step above. We can do this by
        // taking the quotient and remainder when dividing by 40.
        var oidComponents = [UInt]()
        oidComponents.reserveCapacity(subcomponents.count + 1)

        // We'd like to work on the slice here.
        var subcomponentSlice = subcomponents[...]
        guard let firstEncodedSubcomponent = subcomponentSlice.popFirst() else {
            preconditionFailure(
                "Zero components in OID. ISO_8824.ObjectIdentifier validates the encoded format during initialisation and this should be impossible."
            )
        }

        let (firstSubcomponent, secondSubcomponent) = firstEncodedSubcomponent.quotientAndRemainder(dividingBy: 40)
        oidComponents.append(firstSubcomponent)
        oidComponents.append(secondSubcomponent)
        oidComponents.append(contentsOf: subcomponentSlice)
        return oidComponents
    }

    @inlinable
    package static func _writeOIDSubidentifier(_ identifier: UInt, into array: inout [UInt8]) {
        array.writeUsing7BitBytesASN1Discipline(unsignedInteger: identifier)
    }
}

extension ISO_8824.ObjectIdentifier: Hashable {}

extension ISO_8824.ObjectIdentifier: Sendable {}

extension ISO_8824.ObjectIdentifier {
    /// Initializes ``ISO_8824/ObjectIdentifier`` from its OID components
    /// - Parameter elements: The OID components
    @inlinable
    public init(elements: some Swift.Collection<UInt>) throws(ISO_8824.Error) {
        var bytes = [UInt8]()
        var iterator = elements.makeIterator()

        guard let firstComponent = iterator.next(), let secondComponent = iterator.next() else {
            throw ISO_8824.Error.tooFewOIDComponents(
                reason: "Invalid number of OID components: must be at least two!"
            )
        }

        let serializedFirstComponent = (firstComponent * 40) + secondComponent
        ISO_8824.ObjectIdentifier._writeOIDSubidentifier(serializedFirstComponent, into: &bytes)

        while let component = iterator.next() {
            ISO_8824.ObjectIdentifier._writeOIDSubidentifier(component, into: &bytes)
        }
        self.init(_bytes: bytes[...])
    }
}

extension ISO_8824.ObjectIdentifier: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral dotRepresentation: String) {
        // To allow for invalid strings to be tested, parsing is performed in a separate initializer that  `throws`
        // (this initializer conforms to ExpressibleByStringLiteral so cannot throw)
        // REASON: ExpressibleBy*Literal requirement is non-throwing; OID well-formedness is not
        // statically checkable. Throwing form is `init(dotRepresentation:)`.
        // swiftlint:disable:next force_try
        try! self.init(dotRepresentation: dotRepresentation)
    }

    /// Initializes an instance from a `Substring` containing the dot represented OID
    /// - Parameter dotRepresentation: The dot represented OID
    @inlinable
    public init(dotRepresentation: Substring) throws(ISO_8824.Error) {
        let octetArray = dotRepresentation.utf8.split(
            separator: UInt8(ascii: "."),
            omittingEmptySubsequences: false
        )

        let elements = try octetArray.map { (octet) throws(ISO_8824.Error) -> UInt in
            guard let uintOctet = UInt(Substring(octet)) else {
                throw ISO_8824.Error.invalidStringRepresentation(reason: "Invalid octet in OID")
            }
            return uintOctet
        }

        try self.init(elements: elements)
    }

    /// Initializes an instance from a `String` containing the dot represented OID
    /// - Parameter dotRepresentation: The dot represented OID
    @inlinable
    public init(dotRepresentation: String) throws(ISO_8824.Error) {
        try self.init(dotRepresentation: Substring(dotRepresentation))
    }
}

extension ISO_8824.ObjectIdentifier: ExpressibleByArrayLiteral {
    @inlinable
    public init(arrayLiteral elements: UInt...) {
        // REASON: ExpressibleBy*Literal requirement is non-throwing; OID well-formedness is not
        // statically checkable. Throwing form is `init(dotRepresentation:)`.
        // swiftlint:disable:next force_try
        try! self.init(elements: elements)
    }
}

extension ISO_8824.ObjectIdentifier: CustomStringConvertible {
    @inlinable
    public var description: String {
        self.oidComponents.map { String($0) }.joined(separator: ".")
    }
}

extension ArraySlice where Element == UInt8 {
    /// Reads one base-128 subidentifier from the front of the slice.
    ///
    /// Encoded-representation seam shared with ISO 8825 (X.690): long-form tag and
    /// OID subidentifier reads in the transfer-syntax package use this discipline.
    @inlinable
    public mutating func readUIntUsing8BitBytesASN1Discipline() throws(ISO_8824.Error) -> UInt {
        // In principle OID subidentifiers and long tags can be too large to fit into a UInt. We are choosing to not care about that
        // because for us it shouldn't matter.
        guard let subidentifierEndIndex = self.firstIndex(where: { $0 & 0x80 == 0x00 }) else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Invalid encoding for OID subidentifier")
        }

        let oidSlice = self[self.startIndex...subidentifierEndIndex]

        guard let firstByte = oidSlice.first, firstByte != 0x80 else {
            // If the first byte is 0x80 then we have a leading 0 byte. All numbers encoded this way
            // need to be encoded in the minimal number of bytes, so we need to reject this.
            throw ISO_8824.Error.invalidASN1Object(reason: "OID subidentifier encoded with leading 0 byte")
        }

        self = self[self.index(after: subidentifierEndIndex)...]

        // We need to compact the bits. These are 7-bit integers, which is really awkward.
        return try UInt(sevenBitBigEndianBytes: oidSlice)
    }
}

extension UInt {
    /// Assembles an unsigned integer from base-128 (7-bit) big-endian bytes.
    ///
    /// Encoded-representation seam shared with ISO 8825 (X.690): public because the
    /// `@inlinable` seam readers above compose through it.
    @inlinable
    public init<Bytes: Swift.Collection>(sevenBitBigEndianBytes bytes: Bytes) throws(ISO_8824.Error) where Bytes.Element == UInt8 {
        // We need to know how many bytes we _need_ to store this "int". As a base optimization we refuse to parse
        // anything larger than 9 bytes wide, even though conceptually we could fit a few more bits.
        guard ((bytes.count * 7) + 7) / 8 <= MemoryLayout<UInt>.size else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Unable to store OID subidentifier")
        }

        self = 0

        // Unchecked subtraction because bytes.count must be positive, so we can safely subtract 7 after the
        // multiply. The same logic applies to the math in the loop. Finally, the multiply can be unchecked because
        // we already did it above and we didn't overflow there.
        var shift = (bytes.count &* 7) &- 7

        var index = bytes.startIndex
        while shift >= 0 {
            self |= UInt(bytes[index] & 0x7F) << shift
            bytes.formIndex(after: &index)
            shift &-= 7
        }
    }
}

extension Array where Element == UInt8 {
    /// Appends an unsigned integer in base-128 (7-bit) big-endian form.
    ///
    /// Encoded-representation seam shared with ISO 8825 (X.690): long-form tag and
    /// OID subidentifier writes in the transfer-syntax package use this discipline.
    @inlinable
    public mutating func writeUsing7BitBytesASN1Discipline(unsignedInteger identifier: UInt) {
        // An OID subidentifier or long-form tag is written as an integer over 7-bit bytes, where the last byte has the top bit unset.
        // The first thing we need is to know how many bits we need to write
        let bitsToWrite = UInt.bitWidth - identifier.leadingZeroBitCount
        let bytesToWrite = (bitsToWrite + 6) / 7

        guard bytesToWrite > 0 else {
            // Just a zero.
            self.append(0)
            return
        }

        for byteNumber in (1..<bytesToWrite).reversed() {
            let shift = byteNumber * 7
            let byte = UInt8((identifier >> shift) & 0x7f) | 0x80
            self.append(byte)
        }

        // Last byte to append here, we must unset the top bit.
        let byte = UInt8((identifier & 0x7F))
        self.append(byte)
    }
}

// -> ISO 8825: DERImplicitlyTaggable/BERImplicitlyTaggable conformances moved to
// swift-iso-8825 as retroactive extensions:
//   - init(derEncoded:withIdentifier:)  (primitive content-octet extraction; calls
//     `validateObjectIdentifierInEncodedForm`, which REMAINS here — cross-package
//     visibility is a lead decision, currently internal)
//   - init(berEncoded:withIdentifier:)  (delegates to the DER form)
//   - serialize(into:withIdentifier:)   (content-octet emission)
// The base-128 subidentifier read/write helpers above REMAIN here as the canonical
// packed component representation of OID values.
