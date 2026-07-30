// ===----------------------------------------------------------------------===//
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
// ===----------------------------------------------------------------------===//

extension String {
    /// Construct a `String` from an ``ISO_8824/UTF8String``.
    public init(_ utf8String: ISO_8824.UTF8String) {
        self = String(decoding: utf8String.bytes, as: UTF8.self)
    }

    /// Construct a `String` from an ``ISO_8824/PrintableString``.
    public init(_ printableString: ISO_8824.PrintableString) {
        self = String(decoding: printableString.bytes, as: UTF8.self)
    }

    /// Construct a `String` from an ``ISO_8824/VisibleString``.
    public init(_ visibleString: ISO_8824.VisibleString) {
        self = String(decoding: visibleString.bytes, as: UTF8.self)
    }

    /// Construct a `String` from an ``ISO_8824/IA5String``.
    public init(_ ia5String: ISO_8824.IA5String) {
        self = String(decoding: ia5String.bytes, as: UTF8.self)
    }
}
