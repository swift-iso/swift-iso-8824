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

extension ISO_8824.Error.Code {
    @usableFromInline
    enum BackingCode {
        case unexpectedFieldType
        case invalidASN1Object
        case invalidASN1IntegerEncoding
        case truncatedASN1Field
        case unsupportedFieldLength
        case invalidStringRepresentation
        case tooFewOIDComponents
    }
}

extension ISO_8824.Error.Code.BackingCode: Sendable {}
