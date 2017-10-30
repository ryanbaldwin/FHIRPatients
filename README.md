# FHIRPatients - A FireKit Example Project
This is a simple example project which illustrates some of the functionality of [FireKit](https://github.com/ryanbaldwin/FireKit), [Restivus](https://ryanbaldwin.github.io/Restivus), and [Realm](https://github.com/realm/realm-cocoa)

## Requirements
FHIRPatients requires a Swift 4 version of Realm-Cocoa (either v2.10.1 or v2.10.2 will work). This will need to be downloaded and copied manually as Realm currently isn't including the Swift 4 pre-built Carthage framework in their release (it's still using Swift 3.1). See the _Installation_ section below.

It is also recommended to use [Carthage](https://github.com/carthage/carthage) for dependency management, as that will handle the dependencies other than Realm.

## Installation
1. Clone this here project
2. Run `carthage bootstrap --platform iOS --cache-builds`
3. Wait. Realm never released Swift 4 binaries via Carthage (for `realm-cocoa` 2.x), so Carthage will build them for you. This will take a while. Go get a coffee.
3. Open the project, build it, sell it for millions 💰

## About the App
This creates a super simple straight app which allows you to 
- Query a remote FHIR server for patients by family name,
- Create, edit, and delete local Patients,
- Upsert remote patients to the local realm,
- POST/PUT a local Patient to a remote FHIR server,
- Get a feel for Restivus, and
- probably witness the occasional crash.
