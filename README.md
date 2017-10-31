# FHIRPatients - A FireKit Example Project
This is a simple example project which illustrates some of the functionality of [FireKit](https://github.com/ryanbaldwin/FireKit), [Restivus](https://ryanbaldwin.github.io/Restivus), and [Realm](https://github.com/realm/realm-cocoa)

## Requirements
FHIRPatients is built using [FireKit](https://github.com/ryanbaldwin/FireKit), [Restivus](https://github.com/ryanbaldwin/Restivus), and [Realm](https://realm.io). FHIRPatients requires Swift 4+.

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
