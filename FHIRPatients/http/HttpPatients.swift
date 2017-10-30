//
//  PatientRequest.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
import FireKit
import Restivus

/// A generic "upload" intended to be used when submitting a `Patient` to a remote FHIR Server.
/// `UploadPatientRequest` conforms to Swift's `Encodable`, and provides its own implementation
/// of the `encode(to:)` function such that it encodes as just the `patient` data, instead of
/// the default key/value pair of "patient"/`data`
class UploadPatientRequest: Encodable {
    /// The patient to be submitted to the server
    var patient: Patient
    
    /// Initializes a new instnce `UploadPatientRequest`
    ///
    /// - Parameter patient: The patient to be uploaded.
    init(_ patient: Patient) {
        self.patient = patient
    }
    
    /// Encodes this instance's `patient` into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    func encode(to encoder: Encoder) {
        var container = encoder.singleValueContainer()
        try! container.encode(patient)
    }
}

/// An `UploadPatientRequest` which will `POST` the Patient to the remote FHIR Server.
class PostPatientRequest: UploadPatientRequest, Authenticating, Postable {
    typealias ResponseType = Patient
    let path = "/Patient"
}

/// An `UploadPatientRequest` which will `put` the Patient to the remote FHIR Server
class UpdatePatientRequest: UploadPatientRequest, Authenticating, Puttable {
    typealias ResponseType = Patient
    var path: String { return "/Patient/\(patient.id!)" }
}

/// A request which finds patients matching (fuzzily) a provided `family` name.
/// Provides a `FireKit.Bundle` of all matches returned by the server.
struct FindPatientsRequest: Authenticating, Gettable {
    typealias ResponseType = FireKit.Bundle
    var path: String { return "/Patient?family=\(familyName)" }
    
    /// The family name of the patients to find.
    var familyName: String
}

/// A request which downloads the Patient with the provided resource ID from the remote FHIR Server.
struct DownloadPatientRequest: Authenticating, Gettable {
    typealias ResponseType = Patient
    var path: String { return "/Patient/\(resourceId)" }
    
    /// The resource ID (i.e. server ID) of the Patient to be downloaded
    var resourceId: String
}
