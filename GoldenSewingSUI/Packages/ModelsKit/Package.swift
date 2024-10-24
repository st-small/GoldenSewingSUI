// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ModelsKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "ModelsKit",
            targets: ["ModelsKit"]),
    ],
    dependencies: [
        .package(name: "Constants", path: "../Constants"),
    ],
    targets: [
        .target(
            name: "ModelsKit",
            dependencies: [
                .product(name: "Constants", package: "Constants"),
            ]
        )
    ]
)
