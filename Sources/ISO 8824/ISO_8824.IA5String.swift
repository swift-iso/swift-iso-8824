extension ISO_8824 {

    public struct IA5String {

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
                    reason: "Invalid bytes for IA5String"
                )
            }
        }
    }
}

extension ISO_8824.IA5String {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .ia5String
    }

    @inlinable
    public init(_ string: String) throws(ISO_8824.Error) {
        self.bytes = ArraySlice(string.utf8)

        guard Self._isValid(self.bytes) else {
            throw ISO_8824.Error.invalidStringRepresentation(reason: "Invalid bytes for IA5String")
        }
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

    @inlinable
    package static func _isValid(_ bytes: ArraySlice<UInt8>) -> Bool {

        bytes.allSatisfy { $0 < 128 }
    }
}

extension ISO_8824.IA5String: Hashable {}

extension ISO_8824.IA5String: Sendable {}

extension ISO_8824.IA5String: ExpressibleByStringLiteral {
    @inlinable
    public init(stringLiteral value: StringLiteralType) {

        try! self.init(contentBytes: ArraySlice(value.utf8))
    }
}
