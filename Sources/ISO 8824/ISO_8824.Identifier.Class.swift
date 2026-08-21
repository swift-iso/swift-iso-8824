extension ISO_8824.Identifier {

    public enum Class: Hashable, Sendable {
        case universal
        case application
        case contextSpecific
        case `private`
    }
}

extension ISO_8824.Identifier.Class {
    @inlinable
    package init(topByteInWireFormat topByte: UInt8) {
        switch topByte >> 6 {
        case 0x00:
            self = .universal

        case 0x01:
            self = .application

        case 0x02:
            self = .contextSpecific

        case 0x03:
            self = .private

        default:
            fatalError("Unreachable")
        }
    }

    @inlinable
    package var _topByteFlags: UInt8 {
        switch self {
        case .universal:
            return 0x00

        case .application:
            return 0x01 << 6

        case .contextSpecific:
            return 0x02 << 6

        case .private:
            return 0x03 << 6
        }
    }
}
