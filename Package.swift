// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLearning",
    dependencies: [
        .package(url: "https://github.com/airbnb/swift", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "SwiftLearning",
            dependencies: [],
            path: "Sources"
        )
    ],
    swiftLanguageModes: [.v6]
)
