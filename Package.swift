// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyBinance",
    platforms: [
        // Add support for all platforms starting from a specific version.
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v5),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftyBinance",
            targets: ["SwiftyBinance"]
        )
    ],
    targets: [
        .target(
            name: "SwiftyBinance",
            dependencies: []
        )
    ]
)
