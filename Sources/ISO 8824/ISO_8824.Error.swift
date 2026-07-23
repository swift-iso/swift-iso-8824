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

extension ISO_8824 {
    /// Represents an error thrown from ASN.1 processing.
    ///
    /// This is the shared error currency for the ASN.1 split: swift-iso-8825
    /// (the X.690 transfer syntaxes) imports this module and throws this type,
    /// so the wire-oriented codes below remain here even though the code that
    /// raises them lives in swift-iso-8825.
    ///
    /// This object contains both an error ``code`` and a textual reason for the error,
    /// as well as source code context for the error. When attempting to process a specific
    /// error, users are encouraged to check the ``code``. The additional diagnostic information
    /// is available by using `String(describing:)` to format ``ISO_8824/Error``.
    ///
    /// This type is `Equatable` and `Hashable`, but only the ``code`` field is considered in the
    /// implementation of that behaviour. This makes it relatively easy to test code that throws
    /// a specific error by creating the error type directly in your own code.
    public struct Error: Swift.Error, Hashable, CustomStringConvertible {
        @usableFromInline
        let backing: Backing

        @usableFromInline
        init(backing: Backing) {
            self.backing = backing
        }
    }
}

extension ISO_8824.Error {
    /// Represents the kind of error that was encountered.
    public var code: Code {
        self.backing.code
    }

    private var reason: String {
        self.backing.reason
    }

    private var file: String {
        self.backing.file
    }

    private var line: UInt {
        self.backing.line
    }

    public var description: String {
        "ISO_8824.Error.\(self.code): \(self.reason) \(self.file):\(self.line)"
    }

    /// The ASN.1 tag for the parsed field does not match the tag expected for the field.
    @inline(never)
    public static func unexpectedFieldType(
        _ identifier: ISO_8824.Identifier,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .unexpectedFieldType,
                reason: "\(identifier)",
                file: file,
                line: line
            )
        )
    }

    /// The format of the parsed ASN.1 object does not match the format required for the data type
    /// being decoded.
    @inline(never)
    public static func invalidASN1Object(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .invalidASN1Object,
                reason: reason,
                file: file,
                line: line
            )
        )
    }

    /// An ASN.1 integer was decoded that does not use the minimum number of bytes for its encoding.
    @inline(never)
    public static func invalidASN1IntegerEncoding(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .invalidASN1IntegerEncoding,
                reason: reason,
                file: file,
                line: line
            )
        )
    }

    /// An ASN.1 field was truncated and could not be decoded.
    @inline(never)
    public static func truncatedASN1Field(
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .truncatedASN1Field,
                reason: "",
                file: file,
                line: line
            )
        )
    }

    /// The encoding used for the field length is not supported.
    @inline(never)
    public static func unsupportedFieldLength(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .unsupportedFieldLength,
                reason: reason,
                file: file,
                line: line
            )
        )
    }

    /// A string was invalid.
    @inline(never)
    public static func invalidStringRepresentation(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .invalidStringRepresentation,
                reason: reason,
                file: file,
                line: line
            )
        )
    }

    /// Too few OID components were provided. There must be at least two or more.
    @inline(never)
    public static func tooFewOIDComponents(
        reason: String,
        file: String = #fileID,
        line: UInt = #line
    ) -> ISO_8824.Error {
        return ISO_8824.Error(
            backing: .init(
                code: .tooFewOIDComponents,
                reason: reason,
                file: file,
                line: line
            )
        )
    }
}

