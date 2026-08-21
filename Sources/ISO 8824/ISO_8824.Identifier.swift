extension ISO_8824 {

    public struct Identifier {

        public var tagNumber: UInt

        public var tagClass: Class

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

    public static let objectIdentifier = ISO_8824.Identifier(shortIdentifier: 0x06)

    public static let bitString = ISO_8824.Identifier(shortIdentifier: 0x03)

    public static let octetString = ISO_8824.Identifier(shortIdentifier: 0x04)

    public static let integer = ISO_8824.Identifier(shortIdentifier: 0x02)

    public static let sequence = ISO_8824.Identifier(shortIdentifier: 0x30)

    public static let set = ISO_8824.Identifier(shortIdentifier: 0x31)

    public static let null = ISO_8824.Identifier(shortIdentifier: 0x05)

    public static let boolean = ISO_8824.Identifier(shortIdentifier: 0x01)

    public static let enumerated = ISO_8824.Identifier(shortIdentifier: 0x0a)

    public static let utf8String = ISO_8824.Identifier(shortIdentifier: 0x0c)

    public static let numericString = ISO_8824.Identifier(shortIdentifier: 0x12)

    public static let printableString = ISO_8824.Identifier(shortIdentifier: 0x13)

    public static let teletexString = ISO_8824.Identifier(shortIdentifier: 0x14)

    public static let videotexString = ISO_8824.Identifier(shortIdentifier: 0x15)

    public static let ia5String = ISO_8824.Identifier(shortIdentifier: 0x16)

    public static let graphicString = ISO_8824.Identifier(shortIdentifier: 0x19)

    public static let visibleString = ISO_8824.Identifier(shortIdentifier: 0x1a)

    public static let generalString = ISO_8824.Identifier(shortIdentifier: 0x1b)

    public static let universalString = ISO_8824.Identifier(shortIdentifier: 0x1c)

    public static let bmpString = ISO_8824.Identifier(shortIdentifier: 0x1e)

    public static let generalizedTime = ISO_8824.Identifier(shortIdentifier: 0x18)

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
