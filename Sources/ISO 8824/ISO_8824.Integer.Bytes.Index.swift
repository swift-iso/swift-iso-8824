extension ISO_8824.Integer.Bytes {
    public struct Index {
        @usableFromInline
        var _byteNumber: Int

        @inlinable
        package init(byteNumber: Int) {
            self._byteNumber = byteNumber
        }
    }
}

extension ISO_8824.Integer.Bytes.Index {
    @inlinable
    package var _shift: Integer {

        return Integer((self._byteNumber - 1) * 8)
    }
}

extension ISO_8824.Integer.Bytes.Index: Hashable {}

extension ISO_8824.Integer.Bytes.Index: Sendable {}

extension ISO_8824.Integer.Bytes.Index: Comparable {

    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs._byteNumber > rhs._byteNumber
    }

    @inlinable
    public static func > (lhs: Self, rhs: Self) -> Bool {
        return lhs._byteNumber < rhs._byteNumber
    }

    @inlinable
    public static func <= (lhs: Self, rhs: Self) -> Bool {
        return lhs._byteNumber >= rhs._byteNumber
    }

    @inlinable
    public static func >= (lhs: Self, rhs: Self) -> Bool {
        return lhs._byteNumber <= rhs._byteNumber
    }
}

extension ISO_8824.Integer.Bytes.Index: Strideable {
    @inlinable
    public func advanced(by n: Int) -> Self {
        return Self(byteNumber: self._byteNumber - n)
    }

    @inlinable
    public func distance(to other: Self) -> Int {

        return self._byteNumber - other._byteNumber
    }
}
