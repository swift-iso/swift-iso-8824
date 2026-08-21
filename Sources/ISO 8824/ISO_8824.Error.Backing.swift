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

    @usableFromInline
    static func == (lhs: ISO_8824.Error.Backing, rhs: ISO_8824.Error.Backing) -> Bool {
        return lhs.code == rhs.code
    }

    @usableFromInline
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.code)
    }
}
