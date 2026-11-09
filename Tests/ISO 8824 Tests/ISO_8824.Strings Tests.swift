import Testing

@testable import ISO_8824

enum `ISO_8824.UTF8String Tests` {}

extension `ISO_8824.UTF8String Tests` {
    @Suite
    struct Test {}
}

extension `ISO_8824.UTF8String Tests`.Test {
    @Test
    func `contiguous bytes view matches content`() {
        let string = ISO_8824.UTF8String(contentBytes: [1, 2, 3, 4])
        unsafe string.withUnsafeBytes { #expect(unsafe $0.elementsEqual([1, 2, 3, 4])) }
    }

    @Test
    func `round-trips through String`() {
        let string = "hello, world!"
        let utf8String = ISO_8824.UTF8String(string)
        let newString = String(utf8String)
        #expect(newString == string)
    }
}

enum `ISO_8824.TeletexString Tests` {}

extension `ISO_8824.TeletexString Tests` {
    @Suite
    struct Test {}
}

extension `ISO_8824.TeletexString Tests`.Test {
    @Test
    func `contiguous bytes view matches content`() {
        let string = ISO_8824.TeletexString(contentBytes: [1, 2, 3, 4])
        unsafe string.withUnsafeBytes { #expect(unsafe $0.elementsEqual([1, 2, 3, 4])) }
    }
}

enum `ISO_8824.PrintableString Tests` {}

extension `ISO_8824.PrintableString Tests` {
    @Suite
    struct Test {}
}

extension `ISO_8824.PrintableString Tests`.Test {
    @Test
    func `contiguous bytes view matches content`() throws {
        let string = try ISO_8824.PrintableString(contentBytes: [0x54, 0x65, 0x73, 0x74])
        unsafe string.withUnsafeBytes {
            #expect(unsafe $0.elementsEqual([0x54, 0x65, 0x73, 0x74]))
        }
    }

    @Test
    func `round-trips through String`() throws {
        let string = "hello, world"
        let printableString = try ISO_8824.PrintableString(string)
        let newString = String(printableString)
        #expect(newString == string)
    }

    @Test
    func `rejects characters outside the PrintableString alphabet`() throws {
        let allBytes = (UInt8(0)...UInt8.max)

        let invalidBytes = (UInt8(0)...UInt8(255)).filter {
            switch $0 {
            case UInt8(ascii: "a")...UInt8(ascii: "z"),
                UInt8(ascii: "A")...UInt8(ascii: "Z"),
                UInt8(ascii: "0")...UInt8(ascii: "9"),
                UInt8(ascii: "'"), UInt8(ascii: "("),
                UInt8(ascii: ")"), UInt8(ascii: "+"),
                UInt8(ascii: "-"), UInt8(ascii: "?"),
                UInt8(ascii: ":"), UInt8(ascii: "/"),
                UInt8(ascii: "="), UInt8(ascii: " "),
                UInt8(ascii: ","), UInt8(ascii: "."):
                return false

            default:
                return true
            }
        }

        let validBytes = allBytes.filter { !invalidBytes.contains($0) }

        for byte in invalidBytes {
            #expect(throws: ISO_8824.Error.self) {
                try ISO_8824.PrintableString(contentBytes: [byte])
            }
            #expect(throws: ISO_8824.Error.self) {
                try ISO_8824.PrintableString(String(UnicodeScalar(byte)))
            }
        }

        for byte in validBytes {
            #expect(throws: Never.self) { try ISO_8824.PrintableString(contentBytes: [byte]) }
            #expect(throws: Never.self) {
                try ISO_8824.PrintableString(String(UnicodeScalar(byte)))
            }
        }
    }
}

enum `ISO_8824.VisibleString Tests` {}

extension `ISO_8824.VisibleString Tests` {
    @Suite
    struct Test {}
}

extension `ISO_8824.VisibleString Tests`.Test {
    @Test
    func `contiguous bytes view matches content`() throws {
        let string = try ISO_8824.VisibleString(contentBytes: [0x20, 0x30, 0x7a, 0x7e])
        unsafe string.withUnsafeBytes {
            #expect(unsafe $0.elementsEqual([0x20, 0x30, 0x7a, 0x7e]))
        }
    }

    @Test
    func `round-trips through String`() throws {
        let string = "hello, world"
        let visibleString = try ISO_8824.VisibleString(string)
        let newString = String(visibleString)
        #expect(newString == string)
    }

    @Test
    func `rejects characters outside codes 32 through 126`() throws {
        let allBytes = (UInt8(0)...UInt8.max)
        let invalidBytes = [(UInt8(0)...UInt8(31)), (UInt8(127)...(UInt8.max))].joined()
        let validBytes = allBytes.filter { !invalidBytes.contains($0) }

        for byte in invalidBytes {
            #expect(throws: ISO_8824.Error.self) {
                try ISO_8824.VisibleString(contentBytes: [byte])
            }
            #expect(throws: ISO_8824.Error.self) {
                try ISO_8824.VisibleString(String(UnicodeScalar(byte)))
            }
        }

        for byte in validBytes {
            #expect(throws: Never.self) { try ISO_8824.VisibleString(contentBytes: [byte]) }
            #expect(throws: Never.self) { try ISO_8824.VisibleString(String(UnicodeScalar(byte))) }
        }
    }
}

enum `ISO_8824.UniversalString Tests` {}

extension `ISO_8824.UniversalString Tests` {
    @Suite
    struct Test {}
}

extension `ISO_8824.UniversalString Tests`.Test {
    @Test
    func `contiguous bytes view matches content`() {
        let string = ISO_8824.UniversalString(contentBytes: [1, 2, 3, 4])
        unsafe string.withUnsafeBytes { #expect(unsafe $0.elementsEqual([1, 2, 3, 4])) }
    }

    @Test(
        arguments: [
            (literal: "Te", ucs4: [UInt8]([0, 0, 0, 84, 0, 0, 0, 101])),
            (literal: "中", ucs4: [UInt8]([0, 0, 78, 45])),
            (literal: "😀", ucs4: [UInt8]([0, 1, 246, 0])),
        ]
    )
    func `string literal produces big-endian UCS-4 code points`(literal: String, ucs4: [UInt8]) {
        let string = ISO_8824.UniversalString(stringLiteral: literal)
        #expect(Array(string.bytes) == ucs4)
    }
}

enum `ISO_8824.BMPString Tests` {}

extension `ISO_8824.BMPString Tests` {
    @Suite
    struct Test {}
}

extension `ISO_8824.BMPString Tests`.Test {
    @Test
    func `contiguous bytes view matches content`() {
        let string = ISO_8824.BMPString(contentBytes: [1, 2, 3, 4])
        unsafe string.withUnsafeBytes { #expect(unsafe $0.elementsEqual([1, 2, 3, 4])) }
    }

    @Test(
        arguments: [
            (literal: "Test", utf16: [UInt8]([0, 84, 0, 101, 0, 115, 0, 116])),
            (literal: "Tests", utf16: [UInt8]([0, 84, 0, 101, 0, 115, 0, 116, 0, 115])),
            (literal: "中文", utf16: [UInt8]([78, 45, 101, 135])),
        ]
    )
    func `string literal produces big-endian UTF-16 code units`(literal: String, utf16: [UInt8]) {
        let string = ISO_8824.BMPString(stringLiteral: literal)
        #expect(Array(string.bytes) == utf16)
    }
}

enum `ISO_8824.IA5String Tests` {}

extension `ISO_8824.IA5String Tests` {
    @Suite
    struct Test {}
}

extension `ISO_8824.IA5String Tests`.Test {
    @Test
    func `round-trips through String`() throws {
        let string = "hello, world"
        let ia5String = try ISO_8824.IA5String(string)
        let newString = String(ia5String)
        #expect(newString == string)
    }

    @Test
    func `rejects non-ASCII characters`() throws {
        let invalidBytes = (UInt8(128)...(UInt8.max))
        let validBytes = (UInt8(0)..<UInt8(128))

        for byte in invalidBytes {
            #expect(throws: ISO_8824.Error.self) { try ISO_8824.IA5String(contentBytes: [byte]) }
            #expect(throws: ISO_8824.Error.self) {
                try ISO_8824.IA5String(String(UnicodeScalar(byte)))
            }
        }

        for byte in validBytes {
            #expect(throws: Never.self) { try ISO_8824.IA5String(contentBytes: [byte]) }
            #expect(throws: Never.self) { try ISO_8824.IA5String(String(UnicodeScalar(byte))) }
        }
    }
}
