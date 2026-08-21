extension String {

    public init(_ utf8String: ISO_8824.UTF8String) {
        self = String(decoding: utf8String.bytes, as: UTF8.self)
    }

    public init(_ printableString: ISO_8824.PrintableString) {
        self = String(decoding: printableString.bytes, as: UTF8.self)
    }

    public init(_ visibleString: ISO_8824.VisibleString) {
        self = String(decoding: visibleString.bytes, as: UTF8.self)
    }

    public init(_ ia5String: ISO_8824.IA5String) {
        self = String(decoding: ia5String.bytes, as: UTF8.self)
    }
}
