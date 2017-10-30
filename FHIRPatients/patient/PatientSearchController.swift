//
//  PatientSearchController.swift
//  FHIRPatients
//
//  Created by Ryan Baldwin on 2017-10-26.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

/// Provides a means of searching and displaying patients on a remote FHIR Server.
class PatientSearchController: UITableViewController {
    
    /// The URLSessionDataTask for the currently active server query.
    private var searchTask: URLSessionDataTask?
    
    /// A timer used to delay searches until after the user is done typing.
    private var searchTimer = Timer()
    
    /// An optional callback sent to a target whenever a patient is selected from the search results.
    var didSelectPatientResult: ((Patient) -> ())?
    
    /// Gets/Sets the family name, as entered so far by the patient.
    /// On setting, any previous timer that's been set, or search that is already in progress, will be
    /// invalidated/cancelled, and a new timer will be scheduled to be fired in 500ms which will send
    /// the query with the updated family name.
    var familyName: String? = nil {
        didSet {
            searchTimer.invalidate()
            searchTask?.cancel()
            
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
                guard let familyName = self?.familyName, familyName.count > 0 else { return }
                
                self?.searchTask = try? FindPatientsRequest(familyName: familyName).submit() { result in
                    switch result {
                    case let .failure(error):
                        print(error)
                    case let .success(bundle):
                        self?.remotePatients = bundle.entry.flatMap { $0.resource?.resource as? Patient }
                    }
                }
            }
        }
    }
    
    /// Gets the list of remote patients who have a similar family name to that entered by the user.
    private(set) var remotePatients: [Patient] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return remotePatients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let patient = remotePatients[indexPath.row]
        var fullName = patient.name.first?.family.first?.value ?? familyName
        if let given = patient.name.first?.given.first?.value {
            fullName = "\(fullName!), \(given)"
        }
        
        var dobString: String? = nil
        if let dob = patient.birthDate {
            dobString = DateFormatter.dateOfBirthFormatter.string(from: dob.nsDate)
        }
        
        let details: [String?] = [patient.gender, dobString]
        cell.detailTextLabel?.text = details.flatMap { return $0 }.joined(separator: " - ")
        cell.textLabel?.text = fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectPatientResult?(remotePatients[indexPath.row])
    }
}

extension PatientSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        familyName = searchController.searchBar.text
    }
}
