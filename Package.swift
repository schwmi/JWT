// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "JWT",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "JWT",
            targets: ["JWT"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "JWT",
            dependencies: ["Crypto"],
            path: "Sources"),
        .testTarget(
            name: "JWTTests",
            dependencies: ["JWT"],
            path: "Tests")
    ]
)
