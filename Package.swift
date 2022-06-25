// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "CollectionConcurrencyKit",
  platforms: [.iOS(.v15), .macOS(.v12), .watchOS(.v8), .tvOS(.v15)],
  products: [
    .library(
      name: "CollectionConcurrencyKit",
      targets: ["CollectionConcurrencyKit"]
    )
  ],
  targets: [
    .target(name: "CollectionConcurrencyKit"),
    .testTarget(
      name: "CollectionConcurrencyKitTests",
      dependencies: ["CollectionConcurrencyKit"]
    )
  ]
)
