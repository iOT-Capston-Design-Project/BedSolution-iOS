// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "BedFoundation",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "BedFoundationLogging", targets: ["BedFoundationLogging"]),
        .library(name: "BedFoundationNetworking", targets: ["BedFoundationNetworking"])
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.0")
    ],
    targets: [
        .target(
            name: "BedFoundationLogging",
            dependencies: []),
        .target(
            name: "BedFoundationNetworking",
            dependencies: ["Alamofire"])
    ]
)
