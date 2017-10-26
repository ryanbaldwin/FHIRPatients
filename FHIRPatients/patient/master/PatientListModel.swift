//
//  PatientsModel.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-08.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
import FireKit
import RealmSwift

/// Provides a simple model from which a view controller can display a list of patients,
/// as well as clear all or individual patients from the local Realm.
class PatientListModel {
    
    /// The Realm used by this instance.
    private lazy var realm: Realm? = {
        do {
            let r =  try Realm()
            print(r.configuration.fileURL!)
            return r
        } catch let error {
            print("Failed to load realm: \(error)")
        }
        
        return nil
    }()
    
    /// A list of all patients in the local Realm
    lazy var patients: Results<Patient> = {
        return self.realm!.objects(Patient.self)
    }()
    
    /// Deletes all patients from the device.
    func deleteAllLocalPatients() {
        do {
            try realm?.write {
                realm?.deleteAll()
            }
        } catch let error {
            print(error)
        }
    }
    
    /// Deletes a single patient from the device.
    ///
    /// - Parameter patient: The patient to delete.
    func deleteLocalPatient(_ patient: Patient) {
        try? realm?.write {
            patient.cascadeDelete()
        }
    }
}
