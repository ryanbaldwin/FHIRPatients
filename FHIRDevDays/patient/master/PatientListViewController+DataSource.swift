//
//  DetailViewController+DataSource.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit
import RealmSwift

extension PatientListViewController {
    // MARK: - Table View
    
    func load(_ changes: RealmCollectionChange<Results<Patient>>, into tableView: UITableView?) {
        guard let tableView = tableView else { return }
        refreshControl?.endRefreshing()
        
        switch changes {
        case .initial:
            tableView.reloadData()
        case let .update(_, deletions, insertions, modifications):
            tableView.beginUpdates()
            tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section:0) }), with: .automatic)
            tableView.endUpdates()
        case let .error(error):
            print("Failed to relaod data from realm: \(error)")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.patients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let patient = model.patients[indexPath.row]
        let familyName = patient.name.first?.family.first?.value ?? "Doe"
        let givenName = patient.name.first?.given.first?.value ?? "J."
        cell.textLabel!.text = "\(familyName), \(givenName)"
        return cell
    }
}
