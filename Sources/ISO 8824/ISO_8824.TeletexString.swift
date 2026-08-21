extension ISO_8824 {

    public struct TeletexString {

        public var bytes: ArraySlice<UInt8>

        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) {
            self.bytes = contentBytes
        }
    }
}

extension ISO_8824.TeletexString {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .teletexString
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

extension ISO_8824.TeletexString: Hashable {}

extension ISO_8824.TeletexString: Sendable {}

extension ISO_8824.TeletexString: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        self.init(contentBytes: ArraySlice(value.utf8))
    }
}
