//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftASN1 open source project
//
// Copyright (c) 2021 Apple Inc. and the SwiftASN1 project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftASN1 project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

extension ISO_8824 {
    /// An ASN.1 NULL represents nothing.
    public struct Null: Hashable, Sendable {
        /// Construct a new ASN.1 null.
        @inlinable
        public init() {}
    }
}

extension ISO_8824.Null {
    /// The default identifier for this type.
    ///
    /// Evaluates to ``ISO_8824/Identifier/null``.
    @inlinable
    public static var defaultIdentifier: ISO_8824.Identifier {
        .null
    }
}

// -> ISO 8825: DERImplicitlyTaggable/BERImplicitlyTaggable conformances moved to
// swift-iso-8825 as retroactive extensions:
//   - init(derEncoded:withIdentifier:)  (empty-content check against the wire node)
//   - init(berEncoded:withIdentifier:)
//   - serialize(into:withIdentifier:)
