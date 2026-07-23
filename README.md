# swift-iso-8824

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Swift implementation of ISO/IEC 8824 (ITU-T X.680) — Abstract Syntax Notation One (ASN.1): the abstract value types, their validity rules, and the tag identifier vocabulary, independent of any transfer syntax.

---

## Overview

ASN.1 splits cleanly into notation law and encoding law, and this package carries only the first: the abstract types — `INTEGER`, `BIT STRING`, `OCTET STRING`, `NULL`, `OBJECT IDENTIFIER`, the character string family, `GeneralizedTime`, and `UTCTime` — with their value validity rules enforced at construction, plus the tag class and identifier vocabulary every encoding shares. The BER/DER wire rules (ISO/IEC 8825 / ITU-T X.690) live in [swift-iso-8825](https://github.com/swift-iso/swift-iso-8825), which depends on this module.

Every throwing operation throws the typed `ISO_8824.Error`, so failures are exhaustive at the call site.

## Quick Start

```swift
import ISO_8824

// OBJECT IDENTIFIER from dot notation — validated at construction.
let oid = try ISO_8824.ObjectIdentifier(dotRepresentation: "1.2.840.113549.1.1.11")
oid.oidComponents  // [1, 2, 840, 113549, 1, 1, 11]

// Well-known identifiers ship as named constants.
ISO_8824.ObjectIdentifier.AlgorithmIdentifier.self
ISO_8824.ObjectIdentifier.NamedCurves.self

// Time values carry X.680 validity, not wall-clock policy.
let time = try ISO_8824.GeneralizedTime(
    year: 2026, month: 7, day: 23,
    hours: 12, minutes: 0, seconds: 0, fractionalSeconds: 0
)
```

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-iso/swift-iso-8824.git", branch: "main")
]
```

```swift
.target(
    name: "MyTarget",
    dependencies: [
        .product(name: "ISO 8824", package: "swift-iso-8824")
    ]
)
```

## Related Packages

- [swift-iso-8825](https://github.com/swift-iso/swift-iso-8825) — the ASN.1 encoding rules (BER/DER) for these value types.

## Acknowledgments

This package derives from Apple's [SwiftASN1](https://github.com/apple/swift-asn1); see NOTICE.txt and CONTRIBUTORS.txt for provenance.

## License

Licensed under the Apache License, Version 2.0. See [LICENSE.txt](LICENSE.txt) for details.
