// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "JWT",
    products: [
        .library(
            name: "JWT",
            targets: ["JWT"])
    ],
    dependencies: [
        .package(url: "https://github.com/IBM-Swift/OpenSSL.git", from: "2.2.0")
    ],
    targets: [
        .target(
            name: "JWT",
            dependencies: ["OpenSSL"],
            path: "Sources"),
        .testTarget(
            name: "JWTTests",
            dependencies: ["JWT"],
            path: "Tests")
    ]
)
