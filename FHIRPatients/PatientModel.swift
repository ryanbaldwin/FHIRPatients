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
    private(set) var editingPatientPK: String?
    
    var reference: Reference? {
        guard let patientPk = editingPatientPK,
        let patient = realm.object(ofType: Patient.self, forPrimaryKey: patientPk),
        let patientId = patient.id else { return nil }
        
        return Reference(withReferenceId: "\(Patient.resourceType)/\(patientId)")
    }
    
    var image: UIImage?

    var givenName: String? {
        didSet {
            patientCanSaveChanged?(canSave)
        }
    }
    
    var familyName: String? {
        didSet {
            patientCanSaveChanged?(canSave)
        }
    }
    
    var dateOfBirth: Date? {
        didSet {
            patientCanSaveChanged?(canSave)
        }
    }
    
    var gender: Gender? {
        didSet {
            patientCanSaveChanged?(canSave)
        }
    }
    
    var telecoms: [ContactPoint] = []
    
    var canUploadPatient: Bool {
        guard let patientPk = editingPatientPK else { return false }
        return realm.object(ofType: Patient.self, forPrimaryKey: patientPk) != nil
    }
    
    var canSave: Bool {
        return self.givenName?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0
            && self.familyName?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 > 0
            && self.dateOfBirth != nil
            && self.gender != nil
    }
    
    init(patient: Patient? = nil) {
        guard let patient = patient else { return }
        setup(withPatient: patient)
    }
    
    private func setup(withPatient patient: Patient) {
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
        guard canSave else {
            print("Sorry, but you can't save yet. There are required fields.")
            return
        }
        
        do {
            let  patient = editingPatientPK == nil
                ? Patient()
                : realm.object(ofType: Patient.self, forPrimaryKey: editingPatientPK!) ?? Patient()
            
            try realm.write {
                if patient.name.first == nil {
                    patient.name.append(HumanName())
                }
                
                if patient.name.first!.given.first == nil {
                    patient.name.first!.given.append(RealmString())
                }
                patient.name.first!.given.first!.value = givenName!
                
                if patient.name.first!.family.first == nil {
                    patient.name.first!.family.append(RealmString())
                }
                patient.name.first!.family.first!.value = familyName!
                
                patient.gender = String(describing: self.gender!)
                patient.birthDate = dateOfBirth!.fhir_asDate()
                
                patient.telecom.cascadeDelete()
                patient.telecom.append(objectsIn: Array(telecoms.flatMap { $0.copy() as? ContactPoint }))
                
                if let userImage = image {
                    if let jpeg = UIImageJPEGRepresentation(userImage, 0.8) {
                        if patient.photo.first == nil {
                            patient.photo.append(Attachment())
                        }
                        patient.photo.first!.data = Base64Binary(string: jpeg.base64EncodedString(options: .lineLength64Characters))
                    }
                }
                
                // if this is a new patient, we must add it to the realm.
                if editingPatientPK == nil { realm.add(patient) }
                editingPatientPK = patient.pk
            }
        } catch let error {
            print("Failed to commit transaction when creating/updating patient: \(error)")
        }
    }
    
    func uploadPatient(completion: ((Error?) -> ())? = nil) {
        guard canUploadPatient else {
            print("Cannot upload the patient at this time. Has the patient been saved?")
            return
        }
        
        let patientToUpload = realm.object(ofType: Patient.self, forPrimaryKey: editingPatientPK!)!
        var uploadRequest: AnyRestable<Patient>
        if patientToUpload.id == nil {
            uploadRequest = AnyRestable<Patient>(PostPatientRequest(patientToUpload))
        }  else {
            uploadRequest = AnyRestable<Patient>(UpdatePatientRequest(patientToUpload))
        }
        
        do {
            _ = try uploadRequest.submit() { [weak self] result in
                switch result {
                case let .success(uploadPatient):
                    try! self?.realm.write { patientToUpload.populate(from: uploadPatient)}
                    completion?(nil)
                case let .failure(error):
                    completion?(error)
                }
            }
        } catch let error {
            completion?(error)
        }
    }
}
