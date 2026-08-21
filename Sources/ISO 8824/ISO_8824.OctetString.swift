extension ISO_8824 {

    public struct OctetString {

        public var bytes: ArraySlice<UInt8>

        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) {
            self.bytes = contentBytes
        }
    }
}

extension ISO_8824.OctetString {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .octetString
    }
}

extension ISO_8824.OctetString: Hashable {}

extension ISO_8824.OctetString: Sendable {}

extension ISO_8824.OctetString {
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
