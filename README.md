# swift-iso-8824

Use this package when you need ASN.1 values that are valid by construction, such as object identifiers, times and the restricted character strings, without tying them to an encoding. Start from `ISO_8824.ObjectIdentifier`, `ISO_8824.GeneralizedTime` or `ISO_8824.UTCTime`. To read or write these values as BER or DER bytes, use swift-iso-8825, which builds on this package.

## Laws

- `ISO_8824.GeneralizedTime` accepts years 0 to 9999. `ISO_8824.UTCTime` accepts only 1950 to 2049, the range its two-digit year can name.
- Both time types check the day against the Gregorian calendar, so February 29 exists in 2000 and 2024 but not in 1900 or 2100. Seconds may be 0 to 61, to allow leap seconds. Neither type holds a time zone.
- Times order chronologically, from year down to seconds. `ISO_8824.GeneralizedTime` then compares the fraction, and finally its digits as written.
- A fraction of a second must be at least 0 and less than 1. Given as a `Double`, it is kept as plain decimal digits with no exponent and no trailing zeros, so `0.00001` becomes `00001`. Given as raw digits, it must be ASCII digits only with no trailing zero, and no digits means zero.
- `ISO_8824.GeneralizedTime` keeps the raw digits it was given. Two raw spellings that round to the same `Double` are different values.
- `ISO_8824.ObjectIdentifier.init(dotRepresentation:)` needs at least two arcs, each one or more decimal digits. A sign, an empty arc, or a leading or trailing dot is refused.
- `ISO_8824.ObjectIdentifier.init(encodedForm:)` refuses empty content, a subidentifier with a leading zero byte, a last byte that leaves a subidentifier open, and a subidentifier too large for `UInt`.
- An `ISO_8824.ObjectIdentifier` prints in dot form.
- Writing a value as a string or array literal traps if the value is invalid, where the matching initializer would throw.
- `ISO_8824.PrintableString` allows only ASCII letters and digits, space and the marks ' ( ) + , - . / : = and ?. `ISO_8824.VisibleString` allows bytes 32 to 126 and `ISO_8824.IA5String` bytes 0 to 127. Assigning invalid bytes to `bytes` on any of these three traps.
- `ISO_8824.UTF8String`, `ISO_8824.TeletexString`, `ISO_8824.UniversalString`, `ISO_8824.BMPString` and `ISO_8824.OctetString` take any bytes without checking them.
- An `ISO_8824.BMPString` literal is stored as big-endian UTF-16, and a literal with a character outside the Basic Multilingual Plane traps.
- An `ISO_8824.BitString` has 0 to 7 padding bits, none when it has no bytes, and the padding bits in its last byte must be zero.
- Two `ISO_8824.Error` values are equal when their codes are equal. The reason, file and line are ignored.
