// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription



let package = Package(
	name: "PopAnimation",
	
	platforms: [
		.iOS(.v17),
		.macOS(.v14)
	],
	

	products: [
		.library(
			name: "PopAnimation",
			targets: [
				"PopAnimation"
			]),
	],
	
	
	dependencies: [
		.package(url: "https://github.com/rive-app/rive-ios", exact: "6.5.7" ),
		.package(url: "https://github.com/NewChromantics/PopCommon.SwiftPackage", from: "0.0.7" )		
	],
	
	targets: [

		.target(
			name: "PopAnimation",
			dependencies: 
				[
					.product(name: "RiveRuntime", package: "rive-ios"),
					.product(name: "PopCommon", package: "PopCommon.SwiftPackage"),
				]
		)
	]
)
