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
        navigationItem.largeTitleDisplayMode = .automatic
        
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self,
                                          action: #selector(clearPatients))
        navigationItem.leftBarButtonItem = clearButton
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPatient))
        navigationItem.rightBarButtonItem = addButton
        
        refreshControl?.attributedTitle = NSAttributedString(string: "Grab 20 patients from the server")
        refreshControl?.addTarget(self, action: #selector(loadRemotePatients), for: .valueChanged)
        
        // hook into a realm notification for loading our patients
        notificationToken = model.patients.addNotificationBlock() { [weak self] changes in
            self?.load(changes, into: self?.tableView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc func addPatient(_ sender: Any) {
        let vc = EditPatientViewController(nibName: String(describing: EditPatientViewController.self), bundle: nil)
        vc.model = PatientModel()
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }

    @objc func clearPatients() {
        model.deleteAllLocalPatients()
    }
    
    deinit {
        notificationToken?.stop()
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = model.patients[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.model = PatientModel(patient: object)
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

