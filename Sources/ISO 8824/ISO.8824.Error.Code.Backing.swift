extension ISO.`8824`.Error.Code {
    @usableFromInline
    enum Backing {
        case unexpectedFieldType
        case invalidASN1Object
        case invalidASN1IntegerEncoding
        case truncatedASN1Field
        case unsupportedFieldLength
        case invalidStringRepresentation
        case tooFewOIDComponents
    }
}

extension ISO.`8824`.Error.Code.Backing: Sendable {}
