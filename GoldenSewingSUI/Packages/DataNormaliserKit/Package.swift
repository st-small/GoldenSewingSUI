// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "DataNormaliserKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DataNormaliserKit",
            targets: ["DataNormaliserKit"]),
    ],
    dependencies: [
        .package(name: "CachedDataKit", path: "../CachedDataKit"),
        .package(name: "ModelsKit", path: "../ModelsKit"),
        .package(name: "NetworkKit", path: "../NetworkKit"),
        .package(name: "SwiftDataModule", path: "../SwiftDataModule")
    ],
    targets: [
        .target(
            name: "DataNormaliserKit",
            dependencies: [
                .product(name: "CachedDataKit", package: "CachedDataKit"),
                .product(name: "ModelsKit", package: "ModelsKit"),
                .product(name: "NetworkKit", package: "NetworkKit"),
                .product(name: "SwiftDataModule", package: "SwiftDataModule")
            ]
        ),
        .testTarget(
            name: "DataNormaliserKitTests",
            dependencies: [
                "DataNormaliserKit",
                .product(name: "CachedDataKit", package: "CachedDataKit"),
                .product(name: "ModelsKit", package: "ModelsKit"),
                .product(name: "SwiftDataModule", package: "SwiftDataModule"),
            ]),
    ]
)
