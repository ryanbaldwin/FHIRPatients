//
//  HttpDefaults.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
import Restivus

/// The URL for the FHIR Server used in the URL Requests.
let FHIR_SERVER_BASE_URL = "https://fhirtest.uhn.ca/baseDstu2"

// MARK: - Provide defaults for Restable, and thus all other Restable requests such as `Gettable`, `Postable`, etc.
extension Restable {
    var baseURL: String { return FHIR_SERVER_BASE_URL }
}

// MARK: - Default implementation of the Interceptable protocol which will set the `Prefer` header
//         such that all requests return a representation of the FHIR Resource in question.
extension Interceptable {
    
    /// By default this function simply adds the `Prefer: return=representation` header so that mutating
    /// requests sent to the remote FHIR Server return the JSON representation of the resource
    /// instead of the default `OperationOutcome`.
    ///
    /// - Parameter request: The URLRequest to be modified.
    /// - Returns: The udpated URLRequest, containing the `Prefer` header, to be submitted to the server.
    func intercept(request: URLRequest) -> URLRequest {
        var req = request
        req.setValue("return=representation", forHTTPHeaderField: "Prefer")
        return req
    }
}
