extension ISO_8824.Error {

    public struct Code: Hashable, Sendable, CustomStringConvertible {
        @usableFromInline
        var backingCode: Backing

        @usableFromInline
        init(_ backingCode: Backing) {
            self.backingCode = backingCode
        }
    }
}

extension ISO_8824.Error.Code {

    public static let unexpectedFieldType = ISO_8824.Error.Code(.unexpectedFieldType)

    public static let invalidASN1Object = ISO_8824.Error.Code(.invalidASN1Object)

    public static let invalidASN1IntegerEncoding = ISO_8824.Error.Code(.invalidASN1IntegerEncoding)

    public static let truncatedASN1Field = ISO_8824.Error.Code(.truncatedASN1Field)

    public static let unsupportedFieldLength = ISO_8824.Error.Code(.unsupportedFieldLength)

    public static let invalidStringRepresentation = ISO_8824.Error.Code(
        .invalidStringRepresentation
    )

    public static let tooFewOIDComponents = ISO_8824.Error.Code(.tooFewOIDComponents)

    public var description: String {
        return String(describing: self.backingCode)
    }
}
