# FHIRPatients - A FireKit Example Project
This is a simple example project which illustrates some of the functionality of [FireKit](https://github.com/ryanbaldwin/FireKit), [Restivus](https://ryanbaldwin.github.io/Restivus), and [Realm](https://github.com/realm/realm-cocoa)

## Requirements
The FHIRDevDays Example Project requires a Swift 4 version of Realm-Cocoa (either v2.10.1 or v2.10.2 will work). This will need to be downloaded and copied manually as Realm currently isn't including the Swift 4 pre-built Carthage framework in their release (it's still using Swift 3.1). See the _Installation_ section below.

It is also recommended to use [Carthage](https://github.com/carthage/carthage) for dependency management, as that will handle the dependencies other than Realm.

## Installation
1. Clone this here project
2. Run `carthage bootstrap --platform iOS --cache-builds`
3. [Download the Realm Swift 2.10.2 bundle](https://github.com/realm/realm-cocoa/releases/download/v2.10.2/realm-swift-2.10.2.zip). Unzip it, and copy the contents of the `ios/swift-4.0` directory (`Realm.framework` and `RealmSwift.framework`) into the `Carthage/Build/iOS` directory, located in the root of the FHIRDevDays-Example project directory
4. Open the project, build it, sell it for millions 💰

## About the App
blah de blah blah
