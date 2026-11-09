import Testing

@testable import ISO_8824

enum `ISO_8824.ObjectIdentifier Dot Tests` {}

extension `ISO_8824.ObjectIdentifier Dot Tests` {
    @Suite
    struct `Object identifier dot representation` {
        @Test(arguments: ["1.+2.3", "1.2.-0", "+1.2", "1.2.+3"])
        func `a signed arc is refused`(_ text: String) {
            #expect(throws: ISO_8824.Error.self) {
                try ISO_8824.ObjectIdentifier(dotRepresentation: text)
            }
        }

        @Test(arguments: ["1..2", "1.2.", ".1.2", ""])
        func `an empty arc is refused`(_ text: String) {
            #expect(throws: ISO_8824.Error.self) {
                try ISO_8824.ObjectIdentifier(dotRepresentation: text)
            }
        }

        @Test
        func `a well-formed identifier parses`() throws {
            _ = try ISO_8824.ObjectIdentifier(dotRepresentation: "1.2.840.113549.1.1.11")
        }
    }
}

extension `ISO_8824.ObjectIdentifier Dot Tests` {
    @Suite
    struct `Object identifier leading arcs` {
        @Test(arguments: [[UInt]([1, 50]), [0, 40], [1, 40], [3, 0], [3, 1, 2]])
        func `an out-of-range leading arc is refused`(_ elements: [UInt]) {
            #expect(throws: ISO_8824.Error.self) {
                try ISO_8824.ObjectIdentifier(elements: elements)
            }
        }

        @Test
        func `a second arc that overflows the first subidentifier is refused`() {
            #expect(throws: ISO_8824.Error.self) {
                try ISO_8824.ObjectIdentifier(elements: [2, UInt.max])
            }
        }

        @Test(arguments: ["0.39", "1.39.5", "2.10", "2.50", "2.999.3"])
        func `valid leading arcs round-trip`(_ text: String) throws {
            let identifier = try ISO_8824.ObjectIdentifier(dotRepresentation: text)
            #expect(identifier.description == text)
            let decoded = try ISO_8824.ObjectIdentifier(encodedForm: identifier.bytes)
            #expect(decoded.description == text)
        }
    }
}
