// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CloudUrlButton",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15),
        .tvOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CloudUrlButton",
            targets: ["CloudUrlButton"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Get", from: "2.1.6"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CloudUrlButton",
        dependencies: [ "Get" ]),
        .testTarget(
            name: "CloudUrlButtonTests",
            dependencies: ["CloudUrlButton", "Get"]),
    ]
)
