// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftDESI",
    platforms: [
        .iOS("14"),
        .macOS("11")
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftDESI",
            targets: ["SwiftDESI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/triple7/SwiftQValue", branch: "main"),
        .package(url: "https://github.com/brampf/fitscore.git", branch: "master"),
            .package(url: "https://github.com/brampf/fitskit.git", branch: "master"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftDESI",
            dependencies: [
                .product(name: "SwiftQValue", package: "SwiftQValue"),
                .product(name: "FITSKit", package: "FITSKit"),
]),
        .testTarget(
            name: "SwiftDESITests",
            dependencies: ["SwiftDESI"]
        ),
    ]
)
