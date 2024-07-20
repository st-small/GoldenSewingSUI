// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Utilities",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "Utilities",
            targets: ["Utilities"]),
    ],
    targets: [
        .target(
            name: "Utilities"),
        .testTarget(
            name: "UtilitiesTests",
            dependencies: ["Utilities"]),
    ]
)
