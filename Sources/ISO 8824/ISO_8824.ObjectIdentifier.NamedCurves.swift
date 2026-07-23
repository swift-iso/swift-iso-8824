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
    /// Represents a namespace for OIDs that identify named Elliptic Curves.
    ///
    /// These OIDs are defined in RFC 5480.
    public enum NamedCurves {}
}

@available(*, unavailable)
extension ISO_8824.ObjectIdentifier.NamedCurves: Sendable {}

extension ISO_8824.ObjectIdentifier.NamedCurves {
    /// Represents the NIST P256 curve. Also called `prime256v1`.
    public static let secp256r1: ISO_8824.ObjectIdentifier = [1, 2, 840, 10_045, 3, 1, 7]

    /// Represents the NIST P384 curve.
    public static let secp384r1: ISO_8824.ObjectIdentifier = [1, 3, 132, 0, 34]

    /// Represents the NIST P521 curve.
    public static let secp521r1: ISO_8824.ObjectIdentifier = [1, 3, 132, 0, 35]
}
