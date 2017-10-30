//
//  DateFormatte+Extensions.swift
//  FHIRPatients
//
//  Created by Ryan Baldwin on 2017-10-30.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    /// A formatter used for parsing a UTC Date of an NSDate
    static var dateOfBirthFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeZone = TimeZone(abbreviation: "UTC")
        f.dateStyle = .short
        return f
    }()
}
