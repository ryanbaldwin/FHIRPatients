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
    
    private var previousShadowImage: UIImage?
    private var previousBackgroundImage: UIImage?
    let sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    override func viewWillAppear(_ animated: Bool) {
        print("DetailViewController.viewWillAppear")
        super.viewWillAppear(animated)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("DetailViewController.viewWillDisappear")
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.shadowImage = previousShadowImage
        navigationController?.navigationBar.setBackgroundImage(previousBackgroundImage, for: .default)
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        print("Foo")
    }
}

