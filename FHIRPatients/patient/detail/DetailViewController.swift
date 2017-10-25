//
//  DetailViewController.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

class DetailViewController: UITableViewController {
    enum Sections: Int {
        case telecoms, count
    }
    
    @IBOutlet weak var headerView: PatientDetailHeaderView!
    @IBOutlet weak var uploadButton: SequenceStateButton!
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
        return button
    }()
    
    var model: PatientModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView.model = model
        tableView.reloadData()
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        let vc = EditPatientViewController(nibName: String(describing: EditPatientViewController.self), bundle: nil)
        vc.modalTransitionStyle = .crossDissolve
        vc.model = model
        vc.title = "Edit Patient"
        let navController = UINavigationController(rootViewController: vc)
        navigationController?.present(navController, animated: true)
    }
    
    @IBAction func uploadButtonTapped(_ sender: SequenceStateButton) {
        sender.sequenceState = .processing
    }
}

