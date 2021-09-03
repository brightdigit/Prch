// swift-tools-version:5.5
// swiftlint:disable explicit_top_level_acl
import PackageDescription

let package = Package(
  name: "Prch",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v10),
    .tvOS(.v10),
    .watchOS(.v3)
  ],
  products: [
    .library(name: "Prch", targets: ["Prch"])
  ],
  dependencies: [
    .package(url: "https://github.com/shibapm/Komondor", from: "1.1.0"), // dev
    .package(url: "https://github.com/eneko/SourceDocs", from: "1.2.1"), // dev
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.47.0"), // dev
    .package(url: "https://github.com/realm/SwiftLint", from: "0.43.0"), // dev
    .package(
      url: "https://github.com/shibapm/Rocket.git",
      from: "1.2.0"
    ), // dev
    .package(
      url: "https://github.com/mattpolzin/swift-test-codecov",
      .branch("master")
    ), // dev
  ],
  targets: [
    .target(name: "Prch"),
    .testTarget(name: "PrchTests", dependencies: ["Prch"])
  ]
)

#if canImport(PackageConfig)
  import PackageConfig

  let requiredCoverage: Int = 85

  let config = PackageConfiguration([
    "komondor": [
      "pre-push": [
        "swift test --enable-code-coverage --enable-test-discovery",
        // swiftlint:disable:next line_length
        "swift run swift-test-codecov .build/debug/codecov/SyndiKit.json --minimum \(requiredCoverage)"
      ],
      "pre-commit": [
        "swift test --enable-code-coverage --enable-test-discovery --generate-linuxmain",
        "swift run swiftformat .",
        "swift run swiftlint autocorrect",
        "swift run sourcedocs generate build --clean --reproducible-docs --all-modules",
        "git add ."
        // "swift run swiftformat --lint .",
        // "swift run swiftlint"
      ]
    ]
  ]).write()
#endif
