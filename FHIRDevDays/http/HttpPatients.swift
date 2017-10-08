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

struct Random20PatientsRequest: Gettable {
    typealias ResponseType = FireKit.Bundle
    
    var path: String { return "/Patient?_count=20" }
}
