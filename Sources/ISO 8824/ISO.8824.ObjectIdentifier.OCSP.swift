extension ISO.`8824`.ObjectIdentifier {

    public enum OCSP {}
}

@available(*, unavailable)
extension ISO.`8824`.ObjectIdentifier.OCSP: Sendable {}

extension ISO.`8824`.ObjectIdentifier.OCSP {

    public static let basicResponse: ISO.`8824`.ObjectIdentifier = [1, 3, 6, 1, 5, 5, 7, 48, 1, 1]
}
