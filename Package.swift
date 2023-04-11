// swift-tools-version:5.6
// swiftlint:disable explicit_top_level_acl explicit_acl

import PackageDescription

let package = Package(
  name: "Prch",
  platforms: [.macOS(.v12), .iOS(.v14), .watchOS(.v7)],
  products: [
    .library(
      name: "FloxBxNetworking",
      targets: ["FloxBxNetworking"]
    ),
    .library(
      name: "FloxBxModeling",
      targets: ["FloxBxModeling"]
    ),
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
  ],
  targets: [
    .target(name: "FloxBxNetworking", dependencies: ["FloxBxModeling"]),
    .target(name: "FloxBxModeling", dependencies: [])
  ]
)
