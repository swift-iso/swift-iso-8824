extension ISO_8824 {

    public struct Error: Swift.Error, Hashable, CustomStringConvertible {
        @usableFromInline
        let backing: Backing

        @usableFromInline
        init(backing: Backing) {
            self.backing = backing
        }
    }
}

extension ISO_8824.Error {

    public var code: Code {
        self.backing.code
    }

    private var reason: String {
        self.backing.reason
    }

    private var file: String {
        self.backing.file
    }

    private var line: UInt {
        self.backing.line
    }

    public var description: String {
        "ISO_8824.Error.\(self.code): \(self.reason) \(self.file):\(self.line)"
    }

    @inline(never)
    public static func unexpectedFieldType(
        _ identifier: ISO_8824.Identifier,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .unexpectedFieldType,
                reason: "\(identifier)",
                file: file,
                line: line
            )
        )
    }

    @inline(never)
    public static func invalidASN1Object(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .invalidASN1Object,
                reason: reason,
                file: file,
                line: line
            )
        )
    }

    @inline(never)
    public static func invalidASN1IntegerEncoding(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .invalidASN1IntegerEncoding,
                reason: reason,
                file: file,
                line: line
            )
        )
    }

    @inline(never)
    public static func truncatedASN1Field(
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .truncatedASN1Field,
                reason: "",
                file: file,
                line: line
            )
        )
    }

    @inline(never)
    public static func unsupportedFieldLength(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .unsupportedFieldLength,
                reason: reason,
                file: file,
                line: line
            )
        )
    }

    @inline(never)
    public static func invalidStringRepresentation(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .invalidStringRepresentation,
                reason: reason,
                file: file,
                line: line
            )
        )
    }

    @inline(never)
    public static func tooFewOIDComponents(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .tooFewOIDComponents,
                reason: reason,
                file: file,
                line: line
            )
        )
    }
}
