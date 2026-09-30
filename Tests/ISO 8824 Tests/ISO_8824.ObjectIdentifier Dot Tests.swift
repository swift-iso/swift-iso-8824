import Testing

@testable import ISO_8824

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
