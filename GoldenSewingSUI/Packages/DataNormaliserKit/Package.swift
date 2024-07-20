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
        .package(name: "SwiftDataProviderKit", path: "../SwiftDataProviderKit")
    ],
    targets: [
        .target(
            name: "DataNormaliserKit",
            dependencies: [
                .product(name: "CachedDataKit", package: "CachedDataKit"),
                .product(name: "ModelsKit", package: "ModelsKit"),
                .product(name: "NetworkKit", package: "NetworkKit"),
                .product(name: "SwiftDataProviderKit", package: "SwiftDataProviderKit")
            ]
        ),
        .testTarget(
            name: "DataNormaliserKitTests",
            dependencies: [
                "DataNormaliserKit",
                .product(name: "CachedDataKit", package: "CachedDataKit"),
                .product(name: "ModelsKit", package: "ModelsKit"),
                .product(name: "SwiftDataProviderKit", package: "SwiftDataProviderKit"),
            ]),
    ]
)
