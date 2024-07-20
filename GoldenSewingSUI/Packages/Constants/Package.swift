// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Constants",
    platforms: [.iOS(.v17), .macOS(.v10_15)],
    products: [
        .library(
            name: "Constants",
            targets: ["Constants"]),
    ],
    targets: [
        .target(
            name: "Constants",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "ConstantsTests",
            dependencies: ["Constants"]),
    ]
)
