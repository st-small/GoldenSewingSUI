// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureFlag",
	platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "FeatureFlag",
            targets: ["FeatureFlag"]),
    ],
	dependencies: [
	  .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2")
	],
    targets: [
		.target(
			name: "FeatureFlag",
			dependencies: [
				.product(name: "Dependencies", package: "swift-dependencies")
			]
		),
    ]
)
