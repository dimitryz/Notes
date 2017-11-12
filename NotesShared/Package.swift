// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "NotesShared",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", majorVersion: 17)
    ]
)
