extension ISO_8824.ObjectIdentifier {

    public enum NamedCurves {}
}

@available(*, unavailable)
extension ISO_8824.ObjectIdentifier.NamedCurves: Sendable {}

extension ISO_8824.ObjectIdentifier.NamedCurves {

    public static let secp256r1: ISO_8824.ObjectIdentifier = [1, 2, 840, 10_045, 3, 1, 7]

    public static let secp384r1: ISO_8824.ObjectIdentifier = [1, 3, 132, 0, 34]

    public static let secp521r1: ISO_8824.ObjectIdentifier = [1, 3, 132, 0, 35]
}
