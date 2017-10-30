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
    /// Responds to a RealmCollectionChange event wherein the underlying patient list this view is presenting
    /// is modified. Will insert, delete, and reload the appropriate rows to match the underlying changes.
    ///
    /// For more information, check out [Mastering Realm Notifications](https://academy.realm.io/posts/meetup-jp-simard-mastering-realm-notifications/)
    ///
    /// - Parameters:
    ///   - changes: The patients which were deleted, inserted, or updated
    ///   - tableView: The tableview presenting these Patients
    func load(_ changes: RealmCollectionChange<Results<Patient>>, into tableView: UITableView?) {
        guard let tableView = tableView else { return }
        refreshControl?.endRefreshing()
        
        switch changes {
        case .initial:
            tableView.reloadData()
        case let .update(_, deletions, insertions, modifications):
            print("RealmCollectionChange: \(deletions.count) deletions, \(insertions.count) insertions, \(modifications.count) modification")
            tableView.beginUpdates()
            tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
            tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section:0) }), with: .automatic)
            tableView.endUpdates()
        case let .error(error):
            print("Failed to relaod data from realm: \(error)")
        }
        
        navigationItem.leftBarButtonItem?.isEnabled = model.patients.count > 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.patients.count
    }
    
    /// Gets the cell for the patient at the appropriate index. Defaults the patient's name to "J. Doe"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let patient = model.patients[indexPath.row]
        let familyName = patient.name.first?.family.first?.value ?? "Doe"
        let givenName = patient.name.first?.given.first?.value ?? "J."
        cell.textLabel!.text = "\(familyName), \(givenName)"
        return cell
    }
    
    /// Determines if the user can edit the selected patient
    ///
    /// - Parameters:
    ///   - tableView: The tableview containing the patient
    ///   - indexPath: the IndexPath for the cell
    /// - Returns: Always returns true.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Here, because we are doing a UI driven 'write' to the underlying Realm,
            // we want to handle the update to the tableview ourself. Therefore, we will ignore any notification
            // for this transaction.
            model.deleteLocalPatient(model.patients[indexPath.row], ignoreNotificationsFrom: notificationToken)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
