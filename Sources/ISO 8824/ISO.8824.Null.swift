extension ISO.`8824` {

    public struct Null: Hashable, Sendable {

        @inlinable
        public init() {}
    }
}

extension ISO.`8824`.Null {

    @inlinable
    public static var defaultIdentifier: ISO.`8824`.Identifier {
        .null
    }
}
