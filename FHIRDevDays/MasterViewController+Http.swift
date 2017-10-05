//
//  MasterViewController+Http.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import Foundation
import FireKit
import RealmSwift

extension MasterViewController {
    @objc func load20RemotePatients() {
        let request = Random20PatientsRequest()
        _ = try? request.submit(callbackOnMain: false) { [weak self] result in
            switch result {
            case let .success(bundle):
                self?.save(patients: bundle.entry.flatMap { $0.resource?.resource as? Patient })
            case let .failure(error):
                print("Failed to fetch 20 random patients from \(request.fullPath): \(error)")
            }
            
            DispatchQueue.main.async { self?.refreshControl?.endRefreshing() }
        }
    }
    
    func save(patients: [Patient]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(patients)
            }
        } catch let error {
            print("Failed to save patients: \(error)")
        }
    }
}
