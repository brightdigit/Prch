// swift-tools-version:5.6
// swiftlint:disable explicit_top_level_acl explicit_acl

import PackageDescription

let package = Package(
  name: "FloxBx",
  platforms: [.macOS(.v11), .iOS(.v14), .watchOS(.v7)],
  products: [
    .library(
      name: "FloxBxUI",
      targets: ["FloxBxUI"]
    ),
    .library(
      name: "FloxBxServerKit",
      targets: ["FloxBxServerKit"]
    ),
    .executable(name: "fbd", targets: ["fbd"])
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent.git", from: "4.0.0"),
    .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0"),
    .package(url: "https://github.com/brightdigit/Canary.git", from: "0.2.0-beta.1")
  ],
  targets: [
    .executableTarget(
      name: "fbd",
      dependencies: ["FloxBxServerKit"]
    ),
    .target(
      name: "FloxBxModels",
      dependencies: ["FloxBxNetworking"]
    ),
    .target(name: "FloxBxNetworking", dependencies: ["FloxBxAuth"]),
    .target(name: "FloxBxUI", dependencies: [
      "Canary",
      "FloxBxModels",
      "FloxBxAuth",
      "FloxBxGroupActivities"
    ]),
    .target(name: "FloxBxGroupActivities"),
    .target(name: "FloxBxAuth"),
    .target(
      name: "FloxBxServerKit",
      dependencies: [
        .product(name: "Fluent", package: "fluent"),
        .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
        .product(name: "Vapor", package: "vapor"),
        "FloxBxModels",
        "Canary"
      ],
      swiftSettings: [
        .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
      ]
    ),
    .testTarget(
      name: "FloxBxServerKitTests",
      dependencies: [
        "FloxBxServerKit",
        .product(name: "XCTVapor", package: "vapor")
      ]
    )
  ]
)
