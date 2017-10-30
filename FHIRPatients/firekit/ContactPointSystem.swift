//
//  ContactPointSystem.swift
//  FHIRPatients
//
//  Created by Ryan Baldwin on 2017-10-15.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation

/// An enumeration of FHIR's `ContactPointSystem`
enum ContactPointSystem: String {
    /// The value is a telephone number used for voice calls. Use of full international numbers starting with + is
    /// recommended to enable automatic dialing support but not required.
    case phone,
    
    /// The value is a fax machine. Use of full international numbers starting with + is recommended to enable automatic
    /// dialing support but not required.
    fax,
    
    /// The value is an email address
    email,
    
    /// The value is a pager number. These may be local pager numbers that are only usable on a particular pager system.
    pager,
    
    /// A contact that is not a phone, fax, or email address. The format of the value SHOULD be a URL. This is intended
    /// for various personal contacts including blogs, Twitter, Facebook, etc. Do not use for email addresses. If this
    /// is not a URL, then it will require human interpretation.
    other
}
