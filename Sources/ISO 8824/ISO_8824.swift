// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-iso-8824 open source project
//
// Copyright (c) 2026 Coen ten Thije Boonkkamp and the swift-iso-8824 project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// ===----------------------------------------------------------------------===//

/// ISO/IEC 8824 (ITU-T X.680) — Abstract Syntax Notation One (ASN.1):
/// specification of basic notation.
///
/// This module carries the notation-and-value law of ASN.1: the abstract types
/// (BIT STRING, OCTET STRING, INTEGER, NULL, OBJECT IDENTIFIER, the character
/// string types, GeneralizedTime, and UTCTime), their value validity rules, and
/// the tag identifier vocabulary. The transfer-syntax law (BER/CER/DER encoding
/// and decoding per ISO/IEC 8825 / ITU-T X.690) lives in swift-iso-8825, which
/// depends on this module.
public enum ISO_8824 {}
