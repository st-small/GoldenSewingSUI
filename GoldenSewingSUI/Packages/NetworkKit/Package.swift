// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NetworkKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "NetworkKit",
            targets: ["NetworkKit"]),
    ],
    targets: [
        .target(
            name: "NetworkKit"),
        .testTarget(
            name: "NetworkKitTests",
            dependencies: ["NetworkKit"]),
    ]
)
