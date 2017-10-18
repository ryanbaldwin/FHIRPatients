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

class PatientModel {
    enum Gender: Int {
        case male, female, other, unknown
    }
    
    var patientCanSaveChanged: ((Bool) -> ())? = nil
    
    private var realm = try! Realm()
    private var patient: Patient
    private var originalPatient: Patient?
    
    func canSave() -> Bool {
        return self.givenName != nil
            && self.familyName != nil
            && self.dateOfBirth != nil
            && self.gender != nil
    }
    
    lazy var image: UIImage? = {
        guard let base64String = patient.photo.first?.data?.value,
            let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
            let image = UIImage(data: data) else {
            return nil
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
    
    lazy var telecoms: [ContactPoint] = {
        return Array(self.patient.telecom)
    }()
    
    init(patient: Patient? = nil) {
        self.patient = patient?.copy() as? Patient ?? Patient()
        self.originalPatient = patient
        
        givenName = self.patient.name.first?.given.first?.value
        familyName = self.patient.name.first?.family.first?.value
        dateOfBirth = self.patient.birthDate?.nsDate
        
        if let patientGender = self.patient.gender {
            switch patientGender {
            case "male": gender = .male
            case "female": gender = .female
            case "other": gender = .other
            default: gender = .unknown
            }
        }
    }
    
    func save() {
        do {
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
            
            patient.telecom.removeAll()
            patient.telecom.append(objectsIn: telecoms)
            
            if let userImage = image {
                if let jpeg = UIImageJPEGRepresentation(userImage, 0.8) {
                    let attachment = patient.photo.first ?? Attachment()
                    attachment.data = Base64Binary(string: jpeg.base64EncodedString(options: .lineLength64Characters))
                    patient.photo.append(attachment)
                }
            } else if patient.photo.count > 0 {
                 patient.photo.remove(objectAtIndex: 0)
            }
            
            try realm.write {
                if let originalPatient = self.originalPatient, originalPatient.realm != nil {
                    originalPatient.populate(from: patient)
                } else {
                    realm.add(patient, update: true)
                }
            }
        } catch let error {
            print("Failed to commit transaction when creating/updating patient: \(error)")
        }
    }
}
