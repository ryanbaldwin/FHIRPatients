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
import RealmSwift

struct PatientModel {
    enum Gender: Int {
        case male, female, other, unknown
    }
    
    private var realm = try! Realm()
    
    private var patient: Patient
    
    lazy var image: UIImage = {
        guard let base64String = patient.photo.first?.data?.value else {
            return #imageLiteral(resourceName: "user")
        }
        
        guard let data = base64String.data(using: .utf8) else {
            return #imageLiteral(resourceName: "user")
        }
        
        return UIImage(data: data) ?? #imageLiteral(resourceName: "user")
    }()

    lazy var givenName: String? = {
        return self.patient.name.first?.given.first?.value
    }()
    
    lazy var familyName: String? = {
        return self.patient.name.first?.family.first?.value
    }()
    
    lazy var dateOfBirth: Date? = {
        return self.patient.birthDate?.nsDate
    }()
    
    lazy var gender: Gender? = {
        guard let patientGender = self.patient.gender else {
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
        guard let patient = patient else {
            self.patient = Patient()
            self.patient.id = UUID().uuidString
            return
        }
        
        self.patient = patient
    }
    
    mutating func save() {
        do {
            try realm.write {
                let name = patient.name.first ?? HumanName()
                if patient.name.count == 0 { patient.name.append(name) }
                
                if let given = givenName {
                    if name.given.first == nil { name.given.append(RealmString()) }
                    name.given.first!.value = given
                }
                
                if let family = familyName {
                    if name.family.first == nil { name.family.append(RealmString()) }
                    name.family.first!.value = family
                }
                
                if let gender = gender {
                    patient.gender = String(describing: gender)
                }
                
                if let dob = dateOfBirth {
                    patient.birthDate = dob.fhir_asDate()
                }
                
                realm.add(patient, update: true)
            }
        } catch let error {
            print("Failed to commit transaction when creating/updating patient: \(error)")
        }
    }
}
