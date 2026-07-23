//===----------------------------------------------------------------------===//
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
//===----------------------------------------------------------------------===//

extension ISO_8824.ObjectIdentifier {
    /// Represents a namespace for OIDs that identify an algorithm within an
    /// `AlgorithmIdentifier` object.
    public enum AlgorithmIdentifier {}
}

@available(*, unavailable)
extension ISO_8824.ObjectIdentifier.AlgorithmIdentifier: Sendable {}

extension ISO_8824.ObjectIdentifier.AlgorithmIdentifier {
    /// Identifies an elliptic curve public key.
    ///
    /// This identifier is defined in RFC 5480. `AlgorithmIdentifier` objects with this key have a parameters
    /// value defined in that RFC.
    public static let idEcPublicKey: ISO_8824.ObjectIdentifier = [1, 2, 840, 10_045, 2, 1]

    /// Identifies a PKCS#1v1.5 RSA signature using SHA256 as the hash algorithm.
    ///
    /// This identifier is defined in RFC 4055. When used, the parameters MUST be NULL.
    public static let sha256WithRSAEncryption: ISO_8824.ObjectIdentifier = [1, 2, 840, 11_3549, 1, 1, 11]

    /// Identifies a PKCS#1v1.5 RSA signature using SHA384 as the hash algorithm.
    ///
    /// This identifier is defined in RFC 4055. When used, the parameters MUST be NULL.
    public static let sha384WithRSAEncryption: ISO_8824.ObjectIdentifier = [1, 2, 840, 11_3549, 1, 1, 12]

    /// Identifies a PKCS#1v1.5 RSA signature using SHA512 as the hash algorithm.
    ///
    /// This identifier is defined in RFC 4055. When used, the parameters MUST be NULL.
    public static let sha512WithRSAEncryption: ISO_8824.ObjectIdentifier = [1, 2, 840, 11_3549, 1, 1, 13]

    /// Identifies an RSA PSS signature.
    ///
    /// This identifier is defined in RFC 4055. When used, the parameters will be `RSASSA-PSS-params` as
    /// defined in that RFC.
    public static let rsaPSS: ISO_8824.ObjectIdentifier = [1, 2, 840, 11_3549, 1, 1, 10]

    /// Identifies an RSA public key.
    ///
    /// This identifier is defined in RFC 4055. When used, the parameters MUST be NULL.
    public static let rsaEncryption: ISO_8824.ObjectIdentifier = [1, 2, 840, 11_3549, 1, 1, 1]
}
