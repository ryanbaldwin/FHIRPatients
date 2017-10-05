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

class MasterViewController: UITableViewController {
    var detailViewController: DetailViewController? = nil
    
    var notificationToken: NotificationToken? = nil
    lazy var realm: Realm? = {
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
       self.realm?.objects(Patient.self)
    }()!
    
    var patientRefreshControl: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.backgroundColor = .purple
        refresher.tintColor = .white
        let attrs: [NSAttributedStringKey: Any] = [.foregroundColor: UIColor.white]
        refresher.attributedTitle = NSAttributedString(string: "Grab 20 random patients from the server",
                                                       attributes: attrs)
        refresher.addTarget(self, action: #selector(load20RemotePatients), for: [.valueChanged])
        return refresher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        
        refreshControl = patientRefreshControl
        
        // hook into a realm notification for loading our patients
        notificationToken = patients.addNotificationBlock() { [weak self] changes in
            self?.load(changes, into: self?.tableView)
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    deinit {
        notificationToken?.stop()
    }
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = patients[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}

