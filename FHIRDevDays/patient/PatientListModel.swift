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

struct PatientListModel {
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
    
    lazy var patients: Results<Patient> = {
        return self.realm!.objects(Patient.self)
        }()
    
    func loadRemotePatients() {
        let request = Random20PatientsRequest()
        _ = try? request.submit(callbackOnMain: false) { result in
            switch result {
            case let .success(bundle):
                self.save(patients: bundle.entry.flatMap { $0.resource?.resource as? Patient })
            case let .failure(error):
                print("Failed to fetch 20 random patients from \(request.fullPath): \(error)")
            }
            
            //DispatchQueue.main.async { self?.refreshControl?.endRefreshing() }
        }
    }
    
    private func normalizeNames(forPatients patients: [Patient]) {
        patients.forEach { patient in
            let name = patient.name.first ?? HumanName()
            if name.family.count == 0 {
                name.family.append(RealmString(val: "Doe"))
            }
            
            if name.given.count == 0 {
                name.given.append(RealmString(val: "J."))
            }
            
            if patient.name.count == 0 {
                patient.name.append(name)
            }
        }
    }
    
    private func save(patients: [Patient]) {
        normalizeNames(forPatients: patients)
        do {
            let realm = try Realm()
            try realm.write {
                realm.upsert(patients)
            }
        } catch let error {
            print("Failed to save patients: \(error)")
        }
    }
    
    mutating func deleteLocalPatient(_ patient: Patient) {
        try? realm?.write {
            patient.cascadeDelete()
        }
    }
}
