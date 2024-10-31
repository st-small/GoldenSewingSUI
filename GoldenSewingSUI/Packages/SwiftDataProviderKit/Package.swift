// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftDataProviderKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "SwiftDataProviderKit",
            targets: ["SwiftDataProviderKit"]),
    ],
    dependencies: [
        .package(name: "ModelsKit", path: "../ModelsKit"),
    ],
    targets: [
        .target(
            name: "SwiftDataProviderKit",
            dependencies: [
                .product(name: "ModelsKit", package: "ModelsKit"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "SwiftDataProviderKitTests",
            dependencies: ["SwiftDataProviderKit", "ModelsKit"]),
    ]
)
