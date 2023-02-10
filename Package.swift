// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "SwiftUIViewKit",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "SwiftUIViewKit", targets: ["SwiftUIViewKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.5.0"),
    ],
    targets: [
        .target(name: "SwiftUIViewKit",
                dependencies: [
                    .product(name: "SnapKit", package: "SnapKit"),
                    .product(name: "RxSwift", package: "RxSwift"),
                    .product(name: "RxRelay", package: "RxSwift"),
                    .product(name: "RxCocoa", package: "RxSwift"),
                ],
                path: "Sources"),
        .testTarget(name: "SwiftUIViewKitTests", dependencies: ["SwiftUIViewKit"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
