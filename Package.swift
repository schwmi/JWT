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
        .package(url: "https://github.com/vapor-community/copenssl.git", from: "1.0.0-rc.1")
    ],
    targets: [
        .target(
            name: "JWT",
            dependencies: ["COpenSSL"],
            path: "Sources"),
        .testTarget(
            name: "JWTTests",
            dependencies: ["JWT"],
            path: "Tests")
    ]
)
