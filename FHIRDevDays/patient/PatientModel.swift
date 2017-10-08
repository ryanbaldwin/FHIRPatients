//
//  PatientModel.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-08.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
import UIKit
import FireKit

struct PatientModel {
    enum Gender: Int {
        case male, female, other, unknown
    }
    
    private var patient: Patient?
    
    lazy var image: UIImage = {
        guard let base64String = patient?.photo.first?.data?.value else {
            return #imageLiteral(resourceName: "user")
        }
        
        guard let data = base64String.data(using: .utf8) else {
            return #imageLiteral(resourceName: "user")
        }
        
        return UIImage(data: data) ?? #imageLiteral(resourceName: "user")
    }()

    lazy var givenName: String? = {
        return self.patient?.name.first?.given.first?.value
    }()
    
    lazy var familyName: String? = {
        return self.patient?.name.first?.family.first?.value
    }()
    
    lazy var dateOfBirth: Date? = {
        return self.patient?.birthDate?.nsDate
    }()
    
    lazy var gender: Gender? = {
        guard let patientGender = self.patient?.gender else {
            return nil
        }
        
        switch patientGender {
        case "male": return Gender.male
        case "female": return Gender.female
        case "other": return Gender.other
        default: return Gender.unknown
        }
    }()
    
    init(patient: Patient? = nil) {
        self.patient = patient
    }
}
