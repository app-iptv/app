// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LightXMLParser",
    products: [
        .library(
            name: "LightXMLParser",
            targets: ["LightXMLParser"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LightXMLParser",
            dependencies: []),
        .testTarget(
            name: "LightXMLParserTests",
            dependencies: ["LightXMLParser"]),
    ]
)
