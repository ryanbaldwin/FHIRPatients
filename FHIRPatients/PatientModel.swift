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
import Restivus

class PatientModel {
    enum Gender: Int {
        case male, female, other, unknown
    }
    
    var patientCanSaveChanged: ((Bool) -> ())? = nil
    
    private var realm = try! Realm()
    private var editingPatientPK: String?
    
    func canSave() -> Bool {
        return self.givenName != nil
            && self.familyName != nil
            && self.dateOfBirth != nil
            && self.gender != nil
    }
    
    var image: UIImage?

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
    
    var telecoms: [ContactPoint] = []
    
    init(patient: Patient? = nil) {
        guard let patient = patient else { return }
        self.editingPatientPK = patient.pk
        
        givenName = patient.name.first?.given.first?.value
        familyName = patient.name.first?.family.first?.value
        dateOfBirth = patient.birthDate?.nsDate
        telecoms = patient.telecom.flatMap { $0.copy() as? ContactPoint }

        if let patientGender = patient.gender {
            switch patientGender {
            case "male": gender = .male
            case "female": gender = .female
            case "other": gender = .other
            default: gender = .unknown
            }
        }
        
        if let base64String = patient.photo.first?.data?.value,
            let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
            let image = UIImage(data: data) {
                self.image = image
        }
    }
    
    func save() {
        do {
            let patient = Patient()
            let name = HumanName()
            patient.name.append(name)
            
            if let given = givenName {
                name.given.append(RealmString(val: given))
            }
            
            if let family = familyName {
                name.family.append(RealmString(val: family))
            }
            
            if let gender = gender {
                patient.gender = String(describing: gender)
            }
            
            if let dob = dateOfBirth {
                patient.birthDate = dob.fhir_asDate()
            }
            
            patient.telecom.append(objectsIn: telecoms)
            
            if let userImage = image {
                if let jpeg = UIImageJPEGRepresentation(userImage, 0.8) {
                    let attachment = patient.photo.first ?? Attachment()
                    attachment.data = Base64Binary(string: jpeg.base64EncodedString(options: .lineLength64Characters))
                    patient.photo.append(attachment)
                }
            }
            
            if let primaryKey = editingPatientPK, let patientToUpdate = realm.object(ofType: Patient.self,
                                                                                     forPrimaryKey: primaryKey) {
                try realm.write { patientToUpdate.populate(from: patient) }
            } else {
                try realm.write {
                    realm.add(patient)
                    editingPatientPK = patient.pk
                }
            }
        } catch let error {
            print("Failed to commit transaction when creating/updating patient: \(error)")
        }
    }
    
    func uploadPatient(completion: (() -> ())? = nil) {
        guard let patientPK = editingPatientPK,
            let patientToUpload = realm.object(ofType: Patient.self, forPrimaryKey: patientPK) else {
                return
        }
        
        var uploadRequest: AnyRestable<Patient>
        if patientToUpload.id != nil {
            uploadRequest = AnyRestable<Patient>(UpdatePatientRequest(patientToUpload))
        }  else {
            uploadRequest = AnyRestable<Patient>(PostPatientRequest(patientToUpload))
        }
        
        _ = try! uploadRequest.submit() { [weak self] result in
            if case let Result.success(uploadedPatient) = result {
                try! self?.realm.write { patientToUpload.populate(from: uploadedPatient) }
            }
            
            completion?()
        }
    }
}
