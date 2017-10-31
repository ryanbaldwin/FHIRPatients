# FHIRPatients - A FireKit Example Project
This is a simple example project which illustrates some of the functionality of [FireKit](https://github.com/ryanbaldwin/FireKit), [Restivus](https://ryanbaldwin.github.io/Restivus), and [Realm](https://github.com/realm/realm-cocoa)

## Requirements
FHIRPatients is built using [FireKit](https://github.com/ryanbaldwin/FireKit), [Restivus](https://github.com/ryanbaldwin/Restivus), and [Realm](https://realm.io). FHIRPatients requires Swift 4+.

It is also recommended to use [Carthage](https://github.com/carthage/carthage) for dependency management.

## Installation
1. Clone this here project
2. Run `carthage bootstrap --platform iOS --cache-builds`
3. Go get a coffee. Realm never released Swift 4 binaries via Carthage (for `realm-cocoa` 2.x), so Carthage will build them for you. This may take a while.
4. Open the project, build it, sell it for millions 💰

## About the App
This creates a simple app which allows you to 
- Query a remote FHIR server for patients by family name,
- Create, edit, and delete local Patients,
- _Upsert_ (intelligently _update_ or _insert_) remote patients to the local realm,
- POST/PUT a local Patient to a remote FHIR server,
- Get a feel for Restivus, and
- probably witness the occasional crash and/or other bug

## Structure of the App
Firstly, do not get overhwlemed by all the code in this project! The vast majority of the code in this application is for governing the user interface, and not relevant to the capabilities of FireKit, Restivus, or Realm. The actual code for FireKit, Restivus, and Realm is limited to 4 relatively simple files:
- [PatientModel.swift](./FHIRPatients/PatientModel.swift): Defines the ViewModel, consumed by [DetailViewController](./FHIRPatients/patient/detail/DetailViewController.swift), [EditPatientViewController](./FHIRPatients/patient/edit/EditPatientViewController.swift), [PatientDetailHeaderView](./FHIRPatients/patient/detail/PatientDetailHeaderView.swift), and [PatientSearchController.swift](./FHIRPatients/patient/PatientSearchController.swift)
- [HttpPatients.swift](./FHIRPatients/http/HttpPatients.swift): Defines the various REST requests used for communicating with the FHIR Server; specifically:
  - upload (POST & PUT) a `Patient`
  - download (GET) a `Patient`, and
  - search (GET) the server for `Patient`s with a given _family_ name.
- [HttpDefaults.swift](./FHIRPatients/http/HttpDefaults.swift): Defines suitable defaults used by all requests defined in [HttpPatients.swift](./FHIRPatients/http/HttpPatients.swift) by employing Swift protocol extensions.
- [PatientSearchController.swift](./FHIRPatients/patient/PatientSearchController.swift): Defines UISearchController used by [PatientListViewController](./FHIRPatients/patient/master/PatientListViewController.swift), and makes use of the `PatientModel` and `FindPatientsRequest`

A quick perusal of those files should give you an understanding  of some of the functionality of _FireKit_ and _Restivus_.
