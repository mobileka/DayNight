// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DayNight",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        // Appearance logic, kept free of UI so it can be unit tested.
        .target(
            name: "DayNightKit",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        // The menu bar app itself.
        .executableTarget(
            name: "DayNight",
            dependencies: ["DayNightKit"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
        .testTarget(
            name: "DayNightKitTests",
            dependencies: ["DayNightKit"],
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
    ]
)
