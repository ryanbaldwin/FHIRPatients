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

class UploadPatientRequest: Encodable {
    var patient: Patient
    
    init(_ patient: Patient) {
        self.patient = patient
    }
    
    func encode(to encoder: Encoder) {
        var container = encoder.singleValueContainer()
        try! container.encode(patient)
    }
}

class PostPatientRequest: UploadPatientRequest, Authenticating, Postable {
    typealias ResponseType = Patient
    let path = "/Patient"
}

class UpdatePatientRequest: UploadPatientRequest, Authenticating, Puttable {
    typealias ResponseType = Patient
    var path: String { return "/Patient/\(patient.id!)" }
}

struct RefreshPatientRequest: Gettable {
    typealias ResponseType = Patient
    
    var patientId: String
    var path: String { return "/Patient/\(patientId)" }
}

struct FindPatientsRequest: Authenticating, Gettable {
    typealias ResponseType = FireKit.Bundle
    
    var familyName: String
    var path: String { return "/Patient?family=\(familyName)" }
}
