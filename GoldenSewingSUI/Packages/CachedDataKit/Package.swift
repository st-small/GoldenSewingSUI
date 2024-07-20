// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CachedDataKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CachedDataKit",
            targets: ["CachedDataKit"]),
    ],
    dependencies: [
        .package(name: "ModelsKit", path: "../ModelsKit"),
    ],
    targets: [
        .target(
            name: "CachedDataKit",
            dependencies: [
                .product(name: "ModelsKit", package: "ModelsKit"),
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "CachedDataKitTests",
            dependencies: [
                "CachedDataKit",
                .product(name: "ModelsKit", package: "ModelsKit"),
            ]
        ),
    ]
)
