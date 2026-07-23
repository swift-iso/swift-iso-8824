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

extension ISO_8824 {
    /// Namespace for the ASN.1 INTEGER value law.
    public enum Integer {}
}

extension ISO_8824.Integer {
    /// The default identifier for INTEGER values.
    ///
    /// Evaluates to ``ISO_8824/Identifier/integer``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .integer
    }
}
