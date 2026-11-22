extension ISO.`8824`.Integer {

    public protocol Representable {
        associatedtype IntegerBytes: RandomAccessCollection where IntegerBytes.Element == UInt8

        static var isSigned: Bool { get }

        func withBigEndianIntegerBytes<ReturnType, E: Swift::Error>(
            _ body: (IntegerBytes) throws(E) -> ReturnType
        ) throws(E) -> ReturnType
    }
}

extension ISO.`8824`.Integer.Representable where Self: FixedWidthInteger {
    @inlinable
    public func withBigEndianIntegerBytes<ReturnType, E: Swift::Error>(
        _ body: (ISO.`8824`.Integer.Bytes<Self>) throws(E) -> ReturnType
    ) throws(E) -> ReturnType {
        return try body(ISO.`8824`.Integer.Bytes(self))
    }
}

extension Int8: ISO.`8824`.Integer.Representable {}

extension UInt8: ISO.`8824`.Integer.Representable {}

extension Int16: ISO.`8824`.Integer.Representable {}

extension UInt16: ISO.`8824`.Integer.Representable {}

extension Int32: ISO.`8824`.Integer.Representable {}

extension UInt32: ISO.`8824`.Integer.Representable {}

extension Int64: ISO.`8824`.Integer.Representable {}

extension UInt64: ISO.`8824`.Integer.Representable {}

extension Int: ISO.`8824`.Integer.Representable {}

extension UInt: ISO.`8824`.Integer.Representable {}
