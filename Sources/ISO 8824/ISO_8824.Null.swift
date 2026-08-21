extension ISO_8824 {

    public struct Null: Hashable, Sendable {

        @inlinable
        public init() {}
    }
}

extension ISO_8824.Null {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .null
    }
}
