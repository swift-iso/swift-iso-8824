extension ISO_8824 {

    public struct UTF8String {

        public var bytes: ArraySlice<UInt8>

        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) {
            self.bytes = contentBytes
        }
    }
}

extension ISO_8824.UTF8String {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .utf8String
    }

    @inlinable
    public init(_ string: String) {
        self.init(contentBytes: ArraySlice(string.utf8))
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

extension ISO_8824.UTF8String: Hashable {}

extension ISO_8824.UTF8String: Sendable {}

extension ISO_8824.UTF8String: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        self.init(contentBytes: ArraySlice(value.utf8))
    }
}
