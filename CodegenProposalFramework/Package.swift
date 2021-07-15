// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "CodegenProposalFramework",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_14),
    .tvOS(.v12),
    .watchOS(.v5)
  ],
  products: [
    .library(name: "CodegenProposalFramework", targets: ["CodegenProposalFramework"]),
    .executable(name: "RunCodeGen", targets: ["RunCodeGen"]),
  ],
  dependencies: [
    .package(name: "Apollo",
             url: "https://github.com/apollographql/apollo-ios.git",
             .upToNextMajor(from: "0.41.0")),
  ],
  targets: [
    .target(
      name: "CodegenProposalFramework",
      dependencies: [
        .product(name: "Apollo", package: "Apollo"),
      ]
    ),
    .target(
      name: "RunCodeGen",
      dependencies: [
        .product(name: "Apollo", package: "Apollo"),
        .product(name: "ApolloCodegenLib", package: "Apollo"),
        "AnimalsAPI"
      ],
      resources: [
        .process("AnimalSchema.graphqls")
      ]
    ),
    .target(
      name: "AnimalsAPI",
      dependencies: ["AnimalSchema", "CodegenProposalFramework"],
      resources: [.process("GraphQL")]
    ),
    .target(
      name: "AnimalSchema",
      dependencies: ["CodegenProposalFramework"]
    ),
    .testTarget(
      name: "CodegenProposalFrameworkTests",
      dependencies: ["CodegenProposalFramework", "AnimalsAPI"]),
  ]
)
