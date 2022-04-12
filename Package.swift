// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "RESTClient",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .tvOS(.v15),
    .watchOS(.v8)
  ],
  products: [
    .library(
      name: "RESTClient",
      targets: ["RESTClient"]
    ),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "RESTClient",
      dependencies: []),
    .testTarget(
      name: "RESTClientTests",
      dependencies: ["RESTClient"]),
  ]
)
