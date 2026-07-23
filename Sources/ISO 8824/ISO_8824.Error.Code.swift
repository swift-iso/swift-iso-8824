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
    /// Represents the kind of an error.
    ///
    /// The same kind of error may be thrown from more than one place, for more than one reason. This type represents
    /// only a fairly high level kind of error: use the string representation of ``ISO_8824/Error`` to get more details
    /// about the specific cause.
    public struct Code: Hashable, Sendable, CustomStringConvertible {
        @usableFromInline
        var backingCode: BackingCode

        @usableFromInline
        init(_ backingCode: BackingCode) {
            self.backingCode = backingCode
        }
    }
}

extension ISO_8824.Error.Code {
    /// The ASN.1 tag for the parsed field does not match the tag expected for the field.
    public static let unexpectedFieldType = ISO_8824.Error.Code(.unexpectedFieldType)

    /// The format of the parsed ASN.1 object does not match the format required for the data type
    /// being decoded.
    public static let invalidASN1Object = ISO_8824.Error.Code(.invalidASN1Object)

    /// An ASN.1 integer was decoded that does not use the minimum number of bytes for its encoding.
    public static let invalidASN1IntegerEncoding = ISO_8824.Error.Code(.invalidASN1IntegerEncoding)

    /// An ASN.1 field was truncated and could not be decoded.
    public static let truncatedASN1Field = ISO_8824.Error.Code(.truncatedASN1Field)

    /// The encoding used for the field length is not supported.
    public static let unsupportedFieldLength = ISO_8824.Error.Code(.unsupportedFieldLength)

    /// A string was invalid.
    public static let invalidStringRepresentation = ISO_8824.Error.Code(.invalidStringRepresentation)

    /// Too few OID components were provided. There must be at least two or more.
    public static let tooFewOIDComponents = ISO_8824.Error.Code(.tooFewOIDComponents)

    public var description: String {
        return String(describing: self.backingCode)
    }
}
