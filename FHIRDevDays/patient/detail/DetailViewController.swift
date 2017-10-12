//
//  DetailViewController.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-04.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit
import FireKit

class DetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var model: PatientModel?
    
    lazy var imageTitle: UIImageView = {
        let imageView = UIImageView(image: model?.image)
        imageView.backgroundColor = .gray
        imageView.tintColor = .white
        
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
    
    private func configureView() {
        configureTitleView()
        configureNameLabel()
    }
    
    private func configureTitleView() {
        navigationItem.titleView = imageTitle
    }
    
    private func configureNameLabel() {
        let firstName = model?.givenName ?? "J."
        let lastName = model?.familyName ?? "Doe"
        nameLabel.text = "\(firstName) \(lastName)"
    }
}

