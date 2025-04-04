// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "mindZ",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .executable(name: "mindZ", targets: ["mindZ"]),
        .library(name: "mindZLibrary", targets: ["mindZLibrary"])
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "mindZ",
            dependencies: ["mindZLibrary"],
            path: "mac" // Directory containing macOS-specific files, including main.swift
        ),
        .target(
            name: "mindZLibrary",
            dependencies: [],
            path: "src", // Directory containing shared files like NewModel.swift
            //exclude: ["main.swift"] 
        )
    ]
)