extension ISO.`8824`.Error {

    public struct Code: Hashable, Sendable, CustomStringConvertible {
        @usableFromInline
        var backingCode: Backing

        @usableFromInline
        init(_ backingCode: Backing) {
            self.backingCode = backingCode
        }
    }
}

extension ISO.`8824`.Error.Code {

    public static let unexpectedFieldType = ISO.`8824`.Error.Code(.unexpectedFieldType)

    public static let invalidASN1Object = ISO.`8824`.Error.Code(.invalidASN1Object)

    public static let invalidASN1IntegerEncoding = ISO.`8824`.Error.Code(.invalidASN1IntegerEncoding)

    public static let truncatedASN1Field = ISO.`8824`.Error.Code(.truncatedASN1Field)

    public static let unsupportedFieldLength = ISO.`8824`.Error.Code(.unsupportedFieldLength)

    public static let invalidStringRepresentation = ISO.`8824`.Error.Code(
        .invalidStringRepresentation
    )

    public static let tooFewOIDComponents = ISO.`8824`.Error.Code(.tooFewOIDComponents)

    public var description: String {
        return String(describing: self.backingCode)
    }
}
