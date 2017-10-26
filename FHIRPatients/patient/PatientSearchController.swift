//
//  PatientSearchController.swift
//  FHIRPatients
//
//  Created by Ryan Baldwin on 2017-10-26.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

class PatientSearchController: UITableViewController {
    var searchTask: URLSessionDataTask?
    var searchTimer = Timer()
    
    var didSelectPatientResult: ((Patient) -> ())?
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }()
    
    var familyName: String? = nil {
        didSet {
            searchTimer.invalidate()
            searchTask?.cancel()
            
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
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
    
    var remotePatients: [Patient] = [] {
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
            dobString = dateFormatter.string(from: dob.nsDate)
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
