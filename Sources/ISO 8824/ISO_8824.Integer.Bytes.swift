extension ISO_8824.Integer {

    public struct Bytes<Integer: FixedWidthInteger> {
        @usableFromInline var integer: Integer

        @inlinable
        public init(_ integer: Integer) {
            self.integer = integer
        }
    }
}

extension ISO_8824.Integer.Bytes: Hashable {}

extension ISO_8824.Integer.Bytes: Sendable where Integer: Sendable {}

extension ISO_8824.Integer.Bytes: RandomAccessCollection {
    @inlinable
    public var startIndex: Index {
        return Index(byteNumber: Int(self.integer.neededBytes))
    }

    @inlinable
    public var endIndex: Index {
        return Index(byteNumber: 0)
    }

    @inlinable
    public var count: Int {
        return Int(self.integer.neededBytes)
    }

    @inlinable
    public subscript(index: Index) -> UInt8 {

        let shifted = Integer.Magnitude(truncatingIfNeeded: self.integer) >> index._shift
        let masked = shifted & 0xFF
        return UInt8(masked)
    }
}

extension FixedWidthInteger {

    @inlinable
    public var neededBytes: Int {
        let neededBits = self.bitWidth - self.leadingZeroBitCount
        return (neededBits + 7) / 8
    }
}

extension RandomAccessCollection where Element == UInt8 {

    @inlinable
    public func _trimLeadingExcessBytes() -> SubSequence {
        var slice = self[...]
        guard let first = slice.first else {

            return slice
        }

        let wholeByte: UInt8

        switch first {
        case 0:
            wholeByte = 0

        case 0xFF:
            wholeByte = 0xFF

        default:

            return slice
        }

        while slice.count > 1 {

            if slice.first != wholeByte {
                break
            }

            guard let second = slice.dropFirst().first else {
                preconditionFailure("Loop condition violated: must be at least two bytes left")
            }

            if second & 0x80 != wholeByte & 0x80 {

                break
            }

            slice = slice.dropFirst()
        }

        return slice
    }
}

extension UInt8 {

    @inlinable
    public var _topBitSet: Bool {
        return (self & 0x80) != 0
    }
}
