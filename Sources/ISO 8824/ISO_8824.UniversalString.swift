extension ISO_8824 {

    public struct UniversalString {

        public var bytes: ArraySlice<UInt8>

        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) {
            self.bytes = contentBytes
        }
    }
}

extension ISO_8824.UniversalString {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .universalString
    }

    @inlinable
    public func withUnsafeBytes<R, E: Swift::Error>(
        _ body: (UnsafeRawBufferPointer) throws(E) -> R
    ) throws(E) -> R {
        let result = self.bytes.withUnsafeBytes { buffer in
            Result { () throws(E) -> R in unsafe try body(buffer) }
        }
        return try result.get()
    }
}

extension ISO_8824.UniversalString: Hashable {}

extension ISO_8824.UniversalString: Sendable {}

extension ISO_8824.UniversalString: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        self.init(
            contentBytes: ArraySlice(
                // swift-linter:disable:next string utf8 scanning
                // REASON: ISO/IEC 8824-1 (ITU-T X.680): UniversalString is the ISO/IEC 10646 four-octet canonical form, one 32-bit code per Unicode scalar, so the encoding is defined over code points, not UTF-8 bytes.
                value.unicodeScalars.flatMap { scalar in
                    [
                        UInt8(truncatingIfNeeded: scalar.value >> 24),
                        UInt8(truncatingIfNeeded: scalar.value >> 16),
                        UInt8(truncatingIfNeeded: scalar.value >> 8),
                        UInt8(truncatingIfNeeded: scalar.value),
                    ]
                }
            )
        )
    }
}
