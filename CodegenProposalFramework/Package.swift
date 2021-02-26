// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "CodegenProposalFramework",
    products: [
        .library(name: "CodegenProposalFramework", targets: ["CodegenProposalFramework"]),
    ],
    targets: [
        .target(
            name: "CodegenProposalFramework",
            dependencies: []),
        .testTarget(
            name: "CodegenProposalFrameworkTests",
            dependencies: ["CodegenProposalFramework"]),
    ]
)
