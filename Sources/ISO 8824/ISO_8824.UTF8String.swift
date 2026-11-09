extension ISO_8824 {

    public struct UTF8String {

        public var bytes: ArraySlice<UInt8> {
            didSet {
                precondition(Self._isValid(self.bytes))
            }
        }

        @inlinable
        public init(contentBytes: ArraySlice<UInt8>) throws(ISO_8824.Error) {
            self.bytes = contentBytes
            guard Self._isValid(self.bytes) else {
                throw ISO_8824.Error.invalidStringRepresentation(
                    reason: "Invalid bytes for UTF8String"
                )
            }
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
        self.bytes = ArraySlice(string.utf8)
    }

    @inlinable
    package static func _isValid(_ bytes: ArraySlice<UInt8>) -> Bool {
        String(validating: bytes, as: UTF8.self) != nil
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

extension ISO_8824.UTF8String: Hashable {}

extension ISO_8824.UTF8String: Sendable {}

extension ISO_8824.UTF8String: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}
