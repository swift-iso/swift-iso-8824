extension ISO.`8824`.ObjectIdentifier {

    public enum NameAttributes {}
}

@available(*, unavailable)
extension ISO.`8824`.ObjectIdentifier.NameAttributes: Sendable {}

extension ISO.`8824`.ObjectIdentifier.NameAttributes {

    public static let name: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 41]

    public static let surname: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 4]

    public static let givenName: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 42]

    public static let initials: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 43]

    public static let generationQualifier: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 44]

    public static let commonName: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 3]

    public static let localityName: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 7]

    public static let stateOrProvinceName: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 8]

    public static let organizationName: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 10]

    public static let organizationalUnitName: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 11]

    public static let title: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 12]

    public static let dnQualifier: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 46]

    public static let countryName: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 6]

    public static let serialNumber: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 5]

    public static let pseudonym: ISO.`8824`.ObjectIdentifier = [2, 5, 4, 65]

    public static let domainComponent: ISO.`8824`.ObjectIdentifier = [
        0, 9, 2342, 19_200_300, 100, 1, 25,
    ]

    public static let emailAddress: ISO.`8824`.ObjectIdentifier = [1, 2, 840, 113549, 1, 9, 1]
}
