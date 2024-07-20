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
    targets: [
        .target(
            name: "ModelsKit"),
    ]
)
