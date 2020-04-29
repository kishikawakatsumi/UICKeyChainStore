// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "UICKeyChainStore",
    platforms: [
        .macOS(.v10_10), .iOS(.v8), .tvOS(.v9), .watchOS(.v2)
    ],
    products: [
        .library(name: "UICKeyChainStore", targets: ["UICKeyChainStore"])
    ],
    targets: [
        .target(name: "UICKeyChainStore", path: "Lib/UICKeyChainStore", publicHeadersPath: ".")
    ]
)
