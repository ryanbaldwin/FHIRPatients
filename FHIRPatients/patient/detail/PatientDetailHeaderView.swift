//
//  PatientDetailHeaderView.swift
//  FHIRDevDays
//
//  Created by Ryan Baldwin on 2017-10-12.
//  Copyright © 2017 bunnyhug.me. All rights reserved.
//

import UIKit

class PatientDetailHeaderView: UICollectionReusableView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var layout: UIStackView!
    
    var model: PatientModel? {
        didSet {
            configureHeaderView()
        }
    }
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        return f
    }()
    
    private func configureHeaderView() {
        guard var model = self.model else {
            nameLabel.text = nil
            birthLabel.text = nil
            return
        }
        
        nameLabel.text = "\(model.givenName ?? "J.") \(model.familyName ?? "Doe")"
        
        let birthDetails: [String?] = [model.gender != nil ? "\(model.gender!)" : nil,
                                       model.dateOfBirth != nil
                                        ? formatter.string(from: (model.dateOfBirth)!)
                                        : nil]
        let details = birthDetails.flatMap { $0 }.joined(separator: " - ")
        guard details.isEmpty == false else {
            birthLabel.isHidden = true
            return
        }
        
        birthLabel.text = details
    }
    
    override var intrinsicContentSize: CGSize {
        nameLabel.sizeToFit()
        birthLabel.sizeToFit()
        return CGSize(width: UIViewNoIntrinsicMetric,
                      height: nameLabel.bounds.height + birthLabel.bounds.height + layout.spacing)
    }
}
