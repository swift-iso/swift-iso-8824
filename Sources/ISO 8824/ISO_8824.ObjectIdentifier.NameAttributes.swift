// ===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftASN1 open source project
//
// Copyright (c) 2019-2020 Apple Inc. and the SwiftASN1 project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftASN1 project authors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

extension ISO_8824.ObjectIdentifier {
    /// Represents a namespace for OIDs that identify Relative Distinguished Name components.
    ///
    /// An enormous number of these identifiers exist. A non-exhaustive list of them is available in
    /// RFC 4519.
    public enum NameAttributes {}
}

@available(*, unavailable)
extension ISO_8824.ObjectIdentifier.NameAttributes: Sendable {}

extension ISO_8824.ObjectIdentifier.NameAttributes {
    /// The 'name' attribute type is the attribute supertype from which user
    /// attribute types with the name syntax inherit.  Such attribute types
    /// are typically used for naming.  The attribute type is multi-valued.
    public static let name: ISO_8824.ObjectIdentifier = [2, 5, 4, 41]

    /// The 'sn' ('surname' in X.500) attribute type contains name strings
    /// for the family names of a person.
    public static let surname: ISO_8824.ObjectIdentifier = [2, 5, 4, 4]

    /// The 'givenName' attribute type contains name strings that are the
    /// part of a person's name that is not their surname.
    public static let givenName: ISO_8824.ObjectIdentifier = [2, 5, 4, 42]

    /// The 'initials' attribute type contains strings of initials of some or
    /// all of an individual's names, except the surname(s).
    public static let initials: ISO_8824.ObjectIdentifier = [2, 5, 4, 43]

    /// The 'generationQualifier' attribute type contains name strings that
    /// are typically the suffix part of a person's name.
    public static let generationQualifier: ISO_8824.ObjectIdentifier = [2, 5, 4, 44]

    /// The 'cn' ('commonName' in X.500) attribute type contains names of an
    /// object.  If the object corresponds to a person, it is typically the person's full
    /// name.
    ///
    /// In modern usage, the common name typically represents a general identifier of an actor.
    public static let commonName: ISO_8824.ObjectIdentifier = [2, 5, 4, 3]

    /// The 'l' ('localityName' in X.500) attribute type contains names of a
    /// locality or place, such as a city, county, or other geographic
    /// region.
    public static let localityName: ISO_8824.ObjectIdentifier = [2, 5, 4, 7]

    /// The 'st' ('stateOrProvinceName' in X.500) attribute type contains the
    /// full names of states or provinces.
    public static let stateOrProvinceName: ISO_8824.ObjectIdentifier = [2, 5, 4, 8]

    /// The 'o' ('organizationName' in X.500) attribute type contains the
    /// names of an organization.
    public static let organizationName: ISO_8824.ObjectIdentifier = [2, 5, 4, 10]

    /// The 'ou' ('organizationalUnitName' in X.500) attribute type contains
    /// the names of an organizational unit.
    public static let organizationalUnitName: ISO_8824.ObjectIdentifier = [2, 5, 4, 11]

    /// The 'title' attribute type contains the title of a person in their
    /// organizational context.
    public static let title: ISO_8824.ObjectIdentifier = [2, 5, 4, 12]

    /// The 'dnQualifier' attribute type contains disambiguating information
    /// strings to add to the relative distinguished name of an entry.  The
    /// information is intended for use when merging data from multiple
    /// sources in order to prevent conflicts between entries that would
    /// otherwise have the same name.
    public static let dnQualifier: ISO_8824.ObjectIdentifier = [2, 5, 4, 46]

    /// The 'c' ('countryName' in X.500) attribute type contains a two-letter
    /// ISO 3166 [ISO3166] country code.
    public static let countryName: ISO_8824.ObjectIdentifier = [2, 5, 4, 6]

    /// The 'serialNumber' attribute type contains the serial numbers of
    /// devices.
    public static let serialNumber: ISO_8824.ObjectIdentifier = [2, 5, 4, 5]

    /// The pseudonym attribute type contains a pseudonym of the subject.
    public static let pseudonym: ISO_8824.ObjectIdentifier = [2, 5, 4, 65]

    /// The 'dc' ('domainComponent' in RFC 1274) attribute type is a string
    /// holding one component, a label, of a DNS domain name naming a host.
    public static let domainComponent: ISO_8824.ObjectIdentifier = [
        0, 9, 2342, 19_200_300, 100, 1, 25,
    ]

    /// The emailAddress attribute type specifies the electronic-mail address
    /// or addresses of a subject as an unstructured ASCII string.
    public static let emailAddress: ISO_8824.ObjectIdentifier = [1, 2, 840, 113549, 1, 9, 1]
}
