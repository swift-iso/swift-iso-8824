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
    /// Represents a namespace for OIDs corresponding to OCSP identifiers.
    ///
    /// The meaning of these OIDs is defined in RFC 6960.
    public enum OCSP {}
}

@available(*, unavailable)
extension ISO_8824.ObjectIdentifier.OCSP: Sendable {}

extension ISO_8824.ObjectIdentifier.OCSP {
    /// Identifies a `BasicOCSPResponse`.
    public static let basicResponse: ISO_8824.ObjectIdentifier = [1, 3, 6, 1, 5, 5, 7, 48, 1, 1]
}
