//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftASN1 open source project
//
// Copyright (c) 2020 Apple Inc. and the SwiftASN1 project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftASN1 project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

extension ISO_8824.Error {
    @usableFromInline
    final class Backing: Hashable, Sendable {
        @usableFromInline
        let code: ISO_8824.Error.Code

        let reason: String

        let file: String

        let line: UInt

        @usableFromInline
        init(
            code: ISO_8824.Error.Code,
            reason: String,
            file: String,
            line: UInt
        ) {
            self.code = code
            self.reason = reason
            self.file = file
            self.line = line
        }
    }
}

extension ISO_8824.Error.Backing {
    // Only the error code matters for equality.
    @usableFromInline
    static func == (lhs: ISO_8824.Error.Backing, rhs: ISO_8824.Error.Backing) -> Bool {
        return lhs.code == rhs.code
    }

    @usableFromInline
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.code)
    }
}

// Dropped relative to upstream `ASN1Error`: the `invalidPEMDocument` code and factory.
// PEMDocument.swift (the sole Foundation importer) is excluded from BOTH publication
// repos per the rehearsal record, so the code would be dead currency here.
