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
        return imageView
    }()
    
    override func viewDidLoad() {
        configureView()
    }
    
    private func configureView() {
        configureTitleView()
        configureNameLabel()
    }
    
    private func configureTitleView() {
        navigationItem.titleView = imageTitle
        imageTitle.widthAnchor.constraint(equalTo: imageTitle.heightAnchor).isActive = true
        imageTitle.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func configureNameLabel() {
        let firstName = model?.givenName ?? "J."
        let lastName = model?.familyName ?? "Doe"
        navigationItem.title = "\(firstName) \(lastName)"
    }
    
    override func viewDidLayoutSubviews() {
        imageTitle.layer.cornerRadius = 20
    }
}

