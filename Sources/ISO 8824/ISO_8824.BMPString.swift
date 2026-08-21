extension ISO_8824 {

    public struct BMPString {

        public var bytes: ArraySlice<UInt8>

        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) {
            self.bytes = contentBytes
        }
    }
}

extension ISO_8824.BMPString {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .bmpString
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
}

extension ISO_8824.BMPString: Hashable {}

extension ISO_8824.BMPString: Sendable {}

extension ISO_8824.BMPString: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        guard
            value.utf16.allSatisfy({ codeUnit in
                !(0xD800...0xDFFF).contains(codeUnit)
            })
        else {
            fatalError(
                "BMPString cannot contain characters outside the Basic Multilingual Plane: '\(value)'"
            )
        }

        self.init(
            contentBytes: ArraySlice(
                value.utf16.flatMap { codeUnit in
                    [UInt8(truncatingIfNeeded: codeUnit >> 8), UInt8(truncatingIfNeeded: codeUnit)]
                }
            )
        )
    }
}
