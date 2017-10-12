//
//  DetailViewController.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

class DetailViewController: UICollectionViewController {
    enum Sections: Int {
        case contactPoints, count
    }
    
    var model: PatientModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.barTintColor = .clear
        
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        print("Foo")
    }
}

