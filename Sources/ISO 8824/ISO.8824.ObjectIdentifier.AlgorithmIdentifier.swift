extension ISO.`8824`.ObjectIdentifier {

    public enum AlgorithmIdentifier {}
}

@available(*, unavailable)
extension ISO.`8824`.ObjectIdentifier.AlgorithmIdentifier: Sendable {}

extension ISO.`8824`.ObjectIdentifier.AlgorithmIdentifier {

    public static let idEcPublicKey: ISO.`8824`.ObjectIdentifier = [1, 2, 840, 10_045, 2, 1]

    public static let sha256WithRSAEncryption: ISO.`8824`.ObjectIdentifier = [
        1, 2, 840, 11_3549, 1, 1, 11,
    ]

    public static let sha384WithRSAEncryption: ISO.`8824`.ObjectIdentifier = [
        1, 2, 840, 11_3549, 1, 1, 12,
    ]

    public static let sha512WithRSAEncryption: ISO.`8824`.ObjectIdentifier = [
        1, 2, 840, 11_3549, 1, 1, 13,
    ]

    public static let rsaPSS: ISO.`8824`.ObjectIdentifier = [1, 2, 840, 11_3549, 1, 1, 10]

    public static let rsaEncryption: ISO.`8824`.ObjectIdentifier = [1, 2, 840, 11_3549, 1, 1, 1]
}
