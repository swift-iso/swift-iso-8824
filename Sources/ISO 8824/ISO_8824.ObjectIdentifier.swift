extension ISO_8824 {

    public struct ObjectIdentifier {

        public private(set) var bytes: ArraySlice<UInt8>

        @usableFromInline
        init(_bytes bytes: ArraySlice<UInt8>) {
            self.bytes = bytes
        }

        public init(encodedForm bytes: ArraySlice<UInt8>) throws(ISO_8824.Error) {
            try Self.validateObjectIdentifierInEncodedForm(bytes)
            self.bytes = bytes
        }
    }
}

extension ISO_8824.ObjectIdentifier {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .objectIdentifier
    }

    @inlinable
    public static func validateObjectIdentifierInEncodedForm(
        _ content: ArraySlice<UInt8>
    ) throws(ISO_8824.Error) {
        var content = content

        guard content.count >= 1 else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Zero components in OID")
        }

        while content.count > 0 {
            _ = try content.readUIntUsing8BitBytesASN1Discipline()
        }
    }

    @inlinable
    public var oidComponents: [UInt] {
        var content = bytes

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

        var oidComponents = [UInt]()
        oidComponents.reserveCapacity(subcomponents.count + 1)

        var subcomponentSlice = subcomponents[...]
        guard let firstEncodedSubcomponent = subcomponentSlice.popFirst() else {
            preconditionFailure(
                "Zero components in OID. ISO_8824.ObjectIdentifier validates the encoded format during initialisation and this should be impossible."
            )
        }

        let (firstSubcomponent, secondSubcomponent) = firstEncodedSubcomponent.quotientAndRemainder(
            dividingBy: 40
        )
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

        try! self.init(dotRepresentation: dotRepresentation)
    }

    @inlinable
    public init(dotRepresentation: Substring) throws(ISO_8824.Error) {
        let octetArray = dotRepresentation.utf8.split(
            separator: UInt8(ascii: "."),
            omittingEmptySubsequences: false
        )

        let elements = try octetArray.map { octet throws(ISO_8824.Error) -> UInt in
            guard let uintOctet = UInt(Substring(octet)) else {
                throw ISO_8824.Error.invalidStringRepresentation(reason: "Invalid octet in OID")
            }
            return uintOctet
        }

        try self.init(elements: elements)
    }

    @inlinable
    public init(dotRepresentation: String) throws(ISO_8824.Error) {
        try self.init(dotRepresentation: Substring(dotRepresentation))
    }
}

extension ISO_8824.ObjectIdentifier: ExpressibleByArrayLiteral {
    @inlinable
    public init(arrayLiteral elements: UInt...) {

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

    @inlinable
    public mutating func readUIntUsing8BitBytesASN1Discipline() throws(ISO_8824.Error) -> UInt {

        guard let subidentifierEndIndex = self.firstIndex(where: { $0 & 0x80 == 0x00 }) else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Invalid encoding for OID subidentifier")
        }

        let oidSlice = self[self.startIndex...subidentifierEndIndex]

        guard let firstByte = oidSlice.first, firstByte != 0x80 else {

            throw ISO_8824.Error.invalidASN1Object(
                reason: "OID subidentifier encoded with leading 0 byte"
            )
        }

        self = self[self.index(after: subidentifierEndIndex)...]

        return try UInt(sevenBitBigEndianBytes: oidSlice)
    }
}

extension UInt {

    @inlinable
    public init<Bytes: Swift.Collection>(sevenBitBigEndianBytes bytes: Bytes) throws(ISO_8824.Error)
    where Bytes.Element == UInt8 {

        guard ((bytes.count * 7) + 7) / 8 <= MemoryLayout<UInt>.size else {
            throw ISO_8824.Error.invalidASN1Object(reason: "Unable to store OID subidentifier")
        }

        self = 0

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

    @inlinable
    public mutating func writeUsing7BitBytesASN1Discipline(unsignedInteger identifier: UInt) {

        let bitsToWrite = UInt.bitWidth - identifier.leadingZeroBitCount
        let bytesToWrite = (bitsToWrite + 6) / 7

        guard bytesToWrite > 0 else {

            self.append(0)
            return
        }

        for byteNumber in (1..<bytesToWrite).reversed() {
            let shift = byteNumber * 7
            let byte = UInt8((identifier >> shift) & 0x7f) | 0x80
            self.append(byte)
        }

        let byte = UInt8((identifier & 0x7F))
        self.append(byte)
    }
}
