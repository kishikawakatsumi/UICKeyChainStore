// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "UICKeyChainStore",
    products: [
        .library(name: "UICKeyChainStore", targets: ["UICKeyChainStore"])
    ],
    targets: [
        .target(
            name: "UICKeyChainStore",
            path: "Lib/UICKeyChainStore",
            publicHeadersPath: ""
        ),
        .target(
            name: "TestHost",
            path: "Lib/TestHost"
        ),
        .testTarget(
            name: "UICKeyChainStoreTests",
            dependencies: ["UICKeyChainStore", "TestHost"],
            path: "Lib/UICKeyChainStoreTests"
        )
    ]
)
