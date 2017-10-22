//
//  HttpDefaults.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
import Restivus

extension Restable {
    var baseURL: String { return "https://fhirtest.uhn.ca/baseDstu2" }
}

extension Authenticating {
    func sign(request: URLRequest) -> URLRequest {
        var req = request
        req.setValue("return=representation", forHTTPHeaderField: "Prefer")
        return req
    }
}
