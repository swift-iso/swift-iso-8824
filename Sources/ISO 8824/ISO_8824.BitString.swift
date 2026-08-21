extension ISO_8824 {

    public struct BitString {

        @usableFromInline var _bytes: ArraySlice<UInt8>
        @usableFromInline var _paddingBits: Int

        @inlinable
        public init(bytes: ArraySlice<UInt8>, paddingBits: Int = 0) throws(ISO_8824.Error) {
            self._bytes = bytes
            self._paddingBits = paddingBits
            try self._validate()
        }
    }
}

extension ISO_8824.BitString {

    @inlinable
    public var bytes: ArraySlice<UInt8> {
        self._bytes
    }

    @inlinable
    public var paddingBits: Int {
        self._paddingBits
    }
}

extension ISO_8824.BitString {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .bitString
    }

    @inlinable
    package func _validate() throws(ISO_8824.Error) {
        guard (0..<8).contains(self.paddingBits) else {
            throw ISO_8824.Error.invalidASN1Object(
                reason: "Invalid number of padding bits for BitString: \(self.paddingBits)"
            )
        }

        guard let finalByte = self.bytes.last else {
            if self.paddingBits != 0 {

                throw ISO_8824.Error.invalidASN1Object(
                    reason: "Invalid number of padding bits for BitString: \(self.paddingBits)"
                )
            }

            return
        }

        let mask = ~(UInt8.max << self.paddingBits)
        if (finalByte & mask) != 0 {
            throw ISO_8824.Error.invalidASN1Object(
                reason:
                    "Invalid padding bits in BitString: \(self.paddingBits) of padding, \(finalByte) final byte"
            )
        }
    }
}

extension ISO_8824.BitString: Hashable {}

extension ISO_8824.BitString: Sendable {}

extension ISO_8824.BitString {
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
