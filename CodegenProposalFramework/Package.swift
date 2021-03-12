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
             .branch("new-codegen-frontend")),
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
      dependencies: ["CodegenProposalFramework"],
      resources: [.process("GraphQL")]
    ),
    .testTarget(
      name: "CodegenProposalFrameworkTests",
      dependencies: ["CodegenProposalFramework", "AnimalsAPI"]),
  ]
)
