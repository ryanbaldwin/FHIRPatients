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
    
    @IBOutlet weak var avatar: PatientAvatarView!
    var model: PatientModel? {
        didSet {
            if let image = model?.image { avatar.image = image }
            collectionView?.reloadData()
        }
    }
    
    private var previousShadowImage: UIImage?
    private var previousBackgroundImage: UIImage?
    let sectionInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        print("Foo")
    }
}

