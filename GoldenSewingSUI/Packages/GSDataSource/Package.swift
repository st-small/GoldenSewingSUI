// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "GSDataSource",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(name: "CatalogCore", targets: ["CatalogCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.6.0"),
        .package(url: "https://github.com/pointfreeco/sqlite-data", from: "1.4.0"),
    ],
    targets: [
        .target(
            name: "CatalogCore",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SQLiteData", package: "sqlite-data"),
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "CatalogCoreTests",
            dependencies: [
                "CatalogCore",
                .product(name: "DependenciesTestSupport", package: "swift-dependencies"),
            ]
        ),
    ]
)
