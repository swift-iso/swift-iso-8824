extension ISO_8824.ObjectIdentifier {

    public enum OCSP {}
}

@available(*, unavailable)
extension ISO_8824.ObjectIdentifier.OCSP: Sendable {}

extension ISO_8824.ObjectIdentifier.OCSP {

    public static let basicResponse: ISO_8824.ObjectIdentifier = [1, 3, 6, 1, 5, 5, 7, 48, 1, 1]
}
