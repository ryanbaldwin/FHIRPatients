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
    /// - Parameters:
    ///   - patient: The patient to delete.
    ///   - token: When provided, `deleteLocalPatient` will perform the transaction without sending
    ///            notifications back to the NotificationToken. Used if the view wants to manage its own
    ///            UI driven writes. Defaults to nil.
    func deleteLocalPatient(_ patient: Patient, ignoreNotificationsFrom token: NotificationToken? = nil) {
        guard let token = token else {
            try? realm?.write { patient.cascadeDelete() }
            return
        }
        
        realm?.beginWrite()
        patient.cascadeDelete()
        try? realm?.commitWrite(withoutNotifying: [token])
    }
}
