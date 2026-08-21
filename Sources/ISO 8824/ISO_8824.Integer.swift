extension ISO_8824 {

    public enum Integer {}
}

extension ISO_8824.Integer {

    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .integer
    }
}
