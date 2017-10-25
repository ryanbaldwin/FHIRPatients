//
//  HttpDefaults.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
import Restivus

let FHIR_SERVER_BASE_URL = "https://fhirtest.uhn.ca/baseDstu2"

extension Restable {
    var baseURL: String { return FHIR_SERVER_BASE_URL }
}

extension Authenticating {
    func sign(request: URLRequest) -> URLRequest {
        var req = request
        req.setValue("return=representation", forHTTPHeaderField: "Prefer")
        return req
    }
}
