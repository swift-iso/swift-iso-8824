// swift-tools-version: 6.3.3

import PackageDescription

extension String {
    static let iso8824: Self = "ISO 8824"
}

extension Target.Dependency {
    static var iso8824: Self { .target(name: .iso8824) }
}

let package = Package(
    name: "swift-iso-8824",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        .library(name: "ISO 8824", targets: ["ISO 8824"])
    ],
    dependencies: [
        // Byte/byte-parser primitives deps deferred: the retained X.680 value law is
        // stdlib-only today. Add https://github.com/swift-primitives/swift-byte-primitives.git
        // (canonical URL per [PKG-DEP-009]) when the [UInt8] boundary judgment items resolve
        // to Byte substrate (see byte-discipline markers in Sources).
    ],
    targets: [
        .target(
            name: "ISO 8824"
        ),
        .testTarget(
            name: "ISO 8824 Tests",
            dependencies: [
                "ISO 8824"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
