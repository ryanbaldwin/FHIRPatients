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

class PatientListViewController: UITableViewController {
    var model = PatientListModel()
    var detailViewController: DetailViewController? = nil
    var notificationToken: NotificationToken? = nil
    
    @objc func loadRemotePatients() {
        self.model.loadRemotePatients()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        configureInteractions()
        
        // hook into a realm notification for loading our patients
        notificationToken = model.patients.addNotificationBlock() { [weak self] changes in
            self?.load(changes, into: self?.tableView)
        }
    }

    private func configureInteractions() {
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self,
                                          action: #selector(clearPatients))
        clearButton.isEnabled = false
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPatient))
        
        navigationItem.leftBarButtonItem = clearButton
        navigationItem.rightBarButtonItem = addButton
        
//        refreshControl?.attributedTitle = NSAttributedString(string: "Grab 20 patients from the server")
//        refreshControl?.addTarget(self, action: #selector(loadRemotePatients), for: .valueChanged)
    }
    
    @objc func addPatient(_ sender: Any) {
        let vc = EditPatientViewController(nibName: String(describing: EditPatientViewController.self), bundle: nil)
        vc.model = PatientModel()
        vc.title = "New Patient"
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }

    @objc func clearPatients() {
        let alertController = UIAlertController(title: "Clear All Patients",
                                                message: "Are you sure you want to clear all local patients? This cannot be undone.",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Clear'em All!", style: .destructive,
                                                handler: {[weak self] _ in self?.model.deleteAllLocalPatients()}))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel,
                                                handler: {_ in alertController.dismiss(animated: true)}))
        present(alertController, animated: true)
    }
    
    deinit {
        notificationToken?.stop()
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = model.patients[indexPath.row]
                let controller = segue.destination as! DetailViewController
                controller.model = PatientModel(patient: object)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

