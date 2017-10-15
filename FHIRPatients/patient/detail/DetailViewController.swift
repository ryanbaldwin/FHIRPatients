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
    
    @IBOutlet weak var avatar: PatientAvatarView!
    var model: PatientModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        print("Foo")
    }
}

