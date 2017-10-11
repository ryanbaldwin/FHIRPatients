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
    
    var patientCanSaveChanged: ((Bool) -> ())? = nil
    
    private var realm = try! Realm()
    private var patient: Patient
    
    mutating func canSave() -> Bool {
        return self.givenName != nil
            && self.familyName != nil
            && self.dateOfBirth != nil
            && self.gender != nil
    }
    
    lazy var image: UIImage = {
        guard let base64String = patient.photo.first?.data?.value,
            let data = base64String.data(using: .utf8),
            let image = UIImage(data: data) else {
            return #imageLiteral(resourceName: "user")
        }
        
        return image
    }()

    var givenName: String? {
        didSet {
            patientCanSaveChanged?(canSave())
        }
    }
    
    var familyName: String? {
        didSet {
            patientCanSaveChanged?(canSave())
        }
    }
    
    var dateOfBirth: Date? {
        didSet {
            patientCanSaveChanged?(canSave())
        }
    }
    
    var gender: Gender? {
        didSet {
            patientCanSaveChanged?(canSave())
        }
    }
    
    init(patient: Patient? = nil) {
        guard let patient = patient else {
            self.patient = Patient()
            return
        }
        
        self.patient = patient
        givenName = patient.name.first?.given.first?.value
        familyName = patient.name.first?.family.first?.value
        dateOfBirth = patient.birthDate?.nsDate
        
        if let patientGender = patient.gender {
            switch patientGender {
            case "male": gender = .male
            case "female": gender = .female
            case "other": gender = .other
            default: gender = .unknown
            }
        }
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
