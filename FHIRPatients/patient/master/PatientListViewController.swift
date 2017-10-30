//
//  MasterViewController.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import RealmSwift
import FireKit

/// A UITableViewController which displays a list of Patients stored locally on the device.
class PatientListViewController: UITableViewController {
    /// A PatientListModel used to manage the underlying list of Patients for this viewcontroller.
    var model = PatientListModel()
    
    /// A detailed view of a single patient
    var detailViewController: DetailViewController? = nil
    
    /// Used to subscribe to underlying data-update notifications from Realm.
    var notificationToken: NotificationToken? = nil
    
    /// The UISearchController used for searching patients by Family Name on the FHIR server
    lazy var searchController: UISearchController = {
        let resultsController = PatientSearchController(style: .plain)
        resultsController.didSelectPatientResult = { [weak self] patient in
            resultsController.dismiss(animated: true) {
                let controller = UIStoryboard(name: "Main", bundle: nil)
                                .instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                self?.setupDetailController(controller, forPatient: patient)
                self?.navigationController?.pushViewController(controller, animated: true)
            }
        }
        
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Find Remote Patients by Family Name"
        searchController.searchBar.autocapitalizationType = .words
        
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        clearsSelectionOnViewWillAppear = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.searchController = searchController
        
        configureInteractions()
        
        // hook into a realm notification for loading our patients
        notificationToken = model.patients.addNotificationBlock() { [weak self] changes in
            self?.load(changes, into: self?.tableView)
        }
    }

    /// Configures some UI elements with which the user can interact,
    /// such as the `Clear` and `+` UIBarButtonItems.
    private func configureInteractions() {
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self,
                                          action: #selector(clearPatients))
        clearButton.isEnabled = false
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPatient))
        
        navigationItem.leftBarButtonItem = clearButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    /// Presents a ViewController to the user, from which the user may create a new Patient
    ///
    /// - Parameter sender: The target of the touchUpInside which ultimately triggered this function.
    @objc func addPatient(_ sender: Any) {
        let vc = EditPatientViewController(nibName: String(describing: EditPatientViewController.self), bundle: nil)
        vc.model = PatientModel()
        vc.title = "New Patient"
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }

    /// Presents an alert confirmation to the User which, when confirmed,
    /// clears all the patients from the local realm.
    @objc func clearPatients() {
        let alertController = UIAlertController(title: "Clear All Patients",
                                                message: "Are you sure you want to clear all local patients? This cannot be undone.",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Clear'em All!", style: .destructive,
                                                handler: {[weak self] _ in self?.model.deleteAllLocalPatients()}))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    deinit {
        // Make sure we unsubscribe from the Realm notifications when this UIViewController is unloaded.
        notificationToken?.stop()
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let patient = model.patients[indexPath.row]
                let controller = segue.destination as! DetailViewController
                setupDetailController(controller, forPatient: patient)
            }
        }
    }
    
    /// Prepares a DetailViewController to display a given patient.
    ///
    /// - Parameters:
    ///   - controller: The DetailViewController to be prepared
    ///   - patient: The patient the DetailViewController is to display.
    private func setupDetailController(_ controller: DetailViewController, forPatient patient: Patient) {
        controller.model = PatientModel(patient: patient)
        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
    }
}

